part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationRecived extends NotificationState {
  final User user;

  NotificationRecived(this.user);

  @override
  List<Object> get props => [user];
}

class NotificationFailed extends NotificationState {
  final Failure failure;

  NotificationFailed(this.failure);

  @override
  List<Object> get props => [failure];
}
