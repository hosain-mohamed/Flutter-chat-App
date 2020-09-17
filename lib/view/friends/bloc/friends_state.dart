part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();
  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsCheckInternets extends FriendsState {}

class FriendsLoading extends FriendsState {}

class MoreFriendsLoading extends FriendsState {}

class MoreFriendsFailure extends FriendsState {
  final Failure failure;
  const MoreFriendsFailure(this.failure)
      : assert(failure != null, "field must equal value");

  @override
  List<Object> get props => [failure];
}

class FriendsLoadSuccess extends FriendsState {
  final List<UserPresentation> friends;
  final double scrollposition;
  final bool noMoreFriends;
  const FriendsLoadSuccess(this.friends, this.scrollposition,
      [this.noMoreFriends])
      : assert(friends != null, "field must equal value"),
        assert(scrollposition != null, "field must equal value");

  @override
  List<Object> get props => [friends, scrollposition];
}

class FriendsLoadFailure extends FriendsState {
  final Failure failure;
  const FriendsLoadFailure(this.failure)
      : assert(failure != null, "field must equal value");

  @override
  List<Object> get props => [failure];
}

class SearchLoading extends FriendsState {}

class EmptySearchField extends FriendsState {}

class SearchSucceed extends FriendsState {
  final List<UserPresentation> friends;

  const SearchSucceed(this.friends)
      : assert(friends != null, "field must equal value");

  @override
  List<Object> get props => [friends];
}

class SearchFailed extends FriendsState {
  final Failure failure;
  const SearchFailed(this.failure)
      : assert(failure != null, "field must equal value");

  @override
  List<Object> get props => [failure];
}

class ClearSearchLoading extends FriendsState{}
