import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat/models/user_presentation.dart';
import 'package:chat/services/authentication_service/authentication_repository.dart';
import 'package:chat/services/storage_service/storage_repository.dart';
import 'package:chat/utils/failure.dart';
import 'package:chat/utils/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final StorageRepository storageRepository;
  final AuthenticationRepository authService;
  final int firstFriendsFetchedNumber = 8;
  final int moreFriendsFetchedNumber = 5;
  int totalFriendsFetchedNumber = 0;
  StreamSubscription<List<UserPresentation>> _streamSubscription;
  List<UserPresentation> users = [];
  String userId;

  FriendsBloc({@required this.storageRepository, @required this.authService})
      : super(FriendsInitial());

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    if (userId == null) {
      userId = await authService.getUserID();
    }
    if (event is FriendsStartFetching) {
      totalFriendsFetchedNumber = firstFriendsFetchedNumber;
      yield* handleFriendsStartFecting();
    } else if (event is MoreFriendsFetched) {
      totalFriendsFetchedNumber += moreFriendsFetchedNumber;
      yield* handleFriendsStartFecting();
    } else if (event is NewFriendsFetched) {
      if (totalFriendsFetchedNumber > firstFriendsFetchedNumber) {
        yield MoreFriendsLoading();
      } else {
        yield FriendsLoading();
      }
      yield FriendsLoadSuccess(event.friends, 0, event.noMoreFriends);
    } else if (event is SearchByName) {
      yield* handleSearchEvent(event);
    } else if (event is ClearSearch) {
      yield ClearSearchLoading();
      yield EmptySearchField();
    }
  }

  Stream<FriendsState> handleSearchEvent(SearchByName event) async* {
    if (event.name.length < 1) {
      yield EmptySearchField();
    } else {
      yield SearchLoading();
      if (!await Functions.getNetworkStatus()) {
        yield SearchFailed(NetworkException());
      } else {
        try {
          final filterdUsers = await storageRepository.searchByName(
              userId: userId, name: event.name);
          yield SearchSucceed(filterdUsers);
        } on Failure catch (failure) {
          yield SearchFailed(failure);
        }
      }
    }
  }

  Stream<FriendsState> handleFriendsStartFecting() async* {
    if (totalFriendsFetchedNumber > firstFriendsFetchedNumber) {
      yield MoreFriendsLoading();
    } else {
      yield FriendsLoading();
    }
    if (!await Functions.getNetworkStatus()) {
      yield FriendsLoadFailure(NetworkException());
    } else {
      try {
        await _streamSubscription?.cancel();
        Stream<List<UserPresentation>> usersStream =
            storageRepository.fetchFirstUsers(
                userId: userId, maxLength: totalFriendsFetchedNumber);
        _streamSubscription = usersStream.listen((event) async {
          users = event;
          if (users.length < totalFriendsFetchedNumber) {
            add(NewFriendsFetched(users, true));
          } else {
            add(NewFriendsFetched(users, false));
          }
        });
      } on Failure catch (failure) {
        yield FriendsLoadFailure(failure);
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
