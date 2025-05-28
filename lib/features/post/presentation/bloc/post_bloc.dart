import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zishan_goldkinentask/features/post/presentation/bloc/post_state.dart';

import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/search_posts.dart';

part 'post_event.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final SearchPosts searchPosts;

  Timer? _debounce;

  PostBloc({
    required this.getPosts,
    required this.searchPosts,
  }) : super(const PostInitial()) {
    on<FetchPostsEvent>((event, emit) async {
      emit(const PostLoading());
      final result = await getPosts();
      result.fold(
            (failure) => emit(PostError(failure.message)),
            (posts) => emit(PostLoaded(posts)),
      );
    });

    on<SearchPostsEvent>((event, emit) async {
      _debounce?.cancel();
      await Future.delayed(const Duration(milliseconds: 500));
      if (event.query.isEmpty) {
        final result = await getPosts();
        result.fold(
              (failure) => emit(PostError(failure.message)),
              (posts) => emit(PostLoaded(posts)),
        );
        return;
      }

      emit(const PostLoading());
      final result = await searchPosts(event.query);
      result.fold(
            (failure) => emit(PostError(failure.message)),
            (posts) => emit(PostLoaded(posts)),
      );
    });

    on<FilterPostsByUserIdEvent>((event, emit) async {
      emit(const PostLoading());
      final result = await getPosts();
      result.fold(
            (failure) => emit(PostError(failure.message)),
            (posts) {
          final filtered =
          posts.where((post) => post.userId == event.userId).toList();
          emit(PostLoaded(filtered));
        },
      );
    });

    on<RefreshPostsEvent>((event, emit) async {
      emit(const PostLoading());
      final result = await getPosts();
      result.fold(
            (failure) => emit(PostError(failure.message)),
            (posts) => emit(PostLoaded(posts)),
      );
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
