part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  FriendsEvent();
  @override
  List<Object> get props => [];
}

class FriendsStartFetching extends FriendsEvent {}

class MoreFriendsFetched extends FriendsEvent {
  final double scrollPosition;

  MoreFriendsFetched(this.scrollPosition);
  List<Object> get props => [scrollPosition];
}

class NewFriendsFetched extends FriendsEvent {
  final List<UserPresentation> friends;
  final bool noMoreFriends;
  NewFriendsFetched(this.friends, [this.noMoreFriends]);
  List<Object> get props => [friends, noMoreFriends];
}

class SearchByName extends FriendsEvent {
  final String name;
  SearchByName(this.name);
  List<Object> get props => [name];
}

class ClearSearch extends FriendsEvent {}
