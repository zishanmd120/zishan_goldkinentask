part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {}

class SearchPostsEvent extends PostEvent {
  final String query;

  const SearchPostsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterPostsByUserIdEvent extends PostEvent {
  final int userId;

  const FilterPostsByUserIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshPostsEvent extends PostEvent {}
