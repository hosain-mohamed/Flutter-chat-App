part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesCheckInternet extends MessagesState {}

class MoreMessagesLoading extends MessagesState {}

class NoMoreMessages extends MessagesState {}

class MoreMessagesFailed extends MessagesState {
  final Failure failure;
  const MoreMessagesFailed(this.failure)
      : assert(failure != null, "field must equal value");

  @override
  List<Object> get props => [failure];
}

class MessagesLoadSucceed extends MessagesState {
  final List<Message> messages;
  final double scrollposition;
  final bool noMoreMessages;
  const MessagesLoadSucceed(
      this.messages, this.scrollposition, [this.noMoreMessages])
      : assert(messages != null, "field must equal value"),
        assert(scrollposition != null, "field must equal value");

  @override
  List<Object> get props => [messages, scrollposition];
}

class MessagesLoadFailed extends MessagesState {
  final Failure failure;
  const MessagesLoadFailed(this.failure)
      : assert(failure != null, "field must equal value");

  @override
  List<Object> get props => [failure];
}

class MessageSentFailure extends MessagesState {
  final Failure failure;
  const MessageSentFailure(this.failure)
      : assert(failure != null, "field must equal value");

  @override
  List<Object> get props => [failure];
}
