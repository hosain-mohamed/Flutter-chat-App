import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/authentication_service/authentication_repository.dart';
import 'package:chat/services/storage_service/storage_repository.dart';
import 'package:chat/utils/failure.dart';
import 'package:chat/utils/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final StorageRepository storageRepository;
  final AuthenticationRepository authRepository;
  final int firstMessagesLength = 15;
  final int moreMessagesLength = 5;
  StreamSubscription<List<Message>> _streamSubscription;
  List<Message> allMessages = [];
  String friendId;
  String userId;
  MessagesBloc(
      {@required this.authRepository, @required this.storageRepository})
      : super(MessagesInitial());

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (userId == null) {
      userId = await authRepository.getUserID();
    }
    if (event is MessagesStartFetching) {
      yield* handleMessagesStartFetchingEvent(event);
    } else if (event is NewMessagesFetched) {
      yield MessagesLoadSucceed(event.messages, 0);
    } else if (event is MoreMessagesFetched) {
      yield* handleMoreMessagesFetchedEvent(event);
    } else if (event is MessageSent) {
      yield* handleMessageSentEvent(event);
    }
  }

  Stream<MessagesState> handleMessagesStartFetchingEvent(
      MessagesStartFetching event) async* {
    yield MessagesLoading();
    if (!await Functions.getNetworkStatus(duration: Duration(milliseconds: 100))) {
      yield MessagesLoadFailed(NetworkException());
    } else {
      try {
        friendId = event.user.userId;
        _streamSubscription?.cancel();
        final messagesStream = storageRepository.fetchFirstMessages(
            userId: userId, friendId: friendId, maxLength: firstMessagesLength);
        _streamSubscription = messagesStream.listen((messages) async {
          messages ??= [];
          // messages have length of 1 then next listen they have length more than 1
          // this behavior I cant explain now
          if (allMessages.length < 1 || allMessages.length < messages.length) {
            allMessages = messages;
          } else {
            allMessages = messages + allMessages.sublist(messages.length - 1);
          }
          if (allMessages.length > 0 && allMessages[0].senderId != userId) {
            storageRepository.markMessageSeen(userId, event.user.userId);
          }
          add(NewMessagesFetched(allMessages));
        });
      } on Failure catch (failure) {
        yield MessagesLoadFailed(failure);
      }
    }
  }

  Stream<MessagesState> handleMoreMessagesFetchedEvent(
      MoreMessagesFetched event) async* {
    yield MoreMessagesLoading();
    if (!await Functions.getNetworkStatus()) {
      yield MoreMessagesFailed(NetworkException());
    } else {
      try {
        final nextMessages = await storageRepository.fetchNextMessages(
          userId: userId,
          friendId: friendId,
          maxLength: moreMessagesLength,
          firstMessagesLength: event.messagesLength,
        );
        allMessages.addAll(nextMessages);

        if (nextMessages.length < moreMessagesLength) {
          yield MessagesLoadSucceed(allMessages, event.scrollposition, true);
        } else {
          yield MessagesLoadSucceed(allMessages, event.scrollposition, false);
        }
      } on Failure catch (failure) {
        yield MoreMessagesFailed(failure);
      }
    }
  }

  Stream<MessagesState> handleMessageSentEvent(MessageSent event) async* {
    yield MessagesCheckInternet();
    if (!await Functions.getNetworkStatus(duration: Duration.zero)) {
      yield MessageSentFailure(NetworkException());
    } else {
      try {
        await storageRepository.sendMessage(
            message: event.message, userId: userId, friendId: event.friendId);
      } on Failure catch (failure) {
        yield MessageSentFailure(failure);
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
