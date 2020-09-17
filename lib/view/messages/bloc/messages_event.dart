part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class MessagesStartFetching extends MessagesEvent {
  final User user;
  MessagesStartFetching(this.user)
      : assert(user != null, "field must equal value");
  List<Object> get props => [user];
}

class NewMessagesFetched extends MessagesEvent {
  final List<Message> messages;
  const NewMessagesFetched(this.messages)
      : assert(messages != null, "field must equal value");
  @override
  List<Object> get props => [messages];
}

class MoreMessagesFetched extends MessagesEvent{
  final int messagesLength ;
  final double scrollposition ;

  MoreMessagesFetched(this.scrollposition, this.messagesLength);
  List<Object> get props => [scrollposition];

}

class MessageSent extends MessagesEvent {
  final String message;
  final String friendId;
  MessageSent({@required this.message, @required this.friendId})
      : assert(message != null, "field must equal value"),
        assert(friendId != null, "field must equal value");
  List<Object> get props => [message, friendId];
}
