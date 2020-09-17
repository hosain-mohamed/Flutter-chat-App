part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class ListenToNotification extends NotificationEvent {}

class NotifcationReceivedEvent extends NotificationEvent {
   final User user;

  NotifcationReceivedEvent(this.user);

  @override
  List<Object> get props => [user];
}
