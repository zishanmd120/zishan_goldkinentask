import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zishan_goldkinentask/core/error/failures.dart';
import 'package:zishan_goldkinentask/features/post/domain/entities/post.dart';
import 'package:zishan_goldkinentask/features/post/domain/usecases/get_posts.dart';
import 'package:zishan_goldkinentask/features/post/domain/usecases/search_posts.dart';
import 'package:zishan_goldkinentask/features/post/presentation/bloc/post_bloc.dart';
import 'package:zishan_goldkinentask/features/post/presentation/bloc/post_state.dart';
import '../../data/mock_post_repository.mocks.dart';

void main() {
  late PostBloc bloc;
  late MockPostRepository mockRepo;
  late GetPosts getPostsUseCase;
  late SearchPosts searchPostsUseCase;

  final posts = [
    const Post(id: 1, userId: 1, title: "Title 1", body: "Body 1"),
    const Post(id: 2, userId: 2, title: "Title 2", body: "Body 2"),
  ];

  setUp(() {
    mockRepo = MockPostRepository();
    getPostsUseCase = GetPosts(mockRepo);
    searchPostsUseCase = SearchPosts(mockRepo);
    bloc = PostBloc(getPosts: getPostsUseCase, searchPosts: searchPostsUseCase);
  });

  blocTest<PostBloc, PostState>(
    'emits [PostLoading, PostLoaded] when posts are fetched successfully',
    build: () {
      when(mockRepo.getPosts()).thenAnswer((_) async => Right(posts));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPostsEvent()),
    expect: () => [
      const PostLoading(),
      PostLoaded(posts),
    ],
  );


  blocTest<PostBloc, PostState>(
    'emits [PostLoading, PostError] when fetching posts fails',
    build: () {
      when(mockRepo.getPosts()).thenAnswer((_) async => Left(TestFailure('error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPostsEvent()),
    expect: () => [
      const PostLoading(),
      const PostError('error'),
    ],
  );

  blocTest<PostBloc, PostState>(
    'emits filtered posts after debounced search',
    build: () {
      when(mockRepo.getPosts()).thenAnswer((_) async => Right(posts));
      when(mockRepo.searchPosts('Title 1')).thenAnswer((_) async => Right([posts[0]]));
      return bloc;
    },
    act: (bloc) async {
      bloc.add(FetchPostsEvent());
      bloc.add(const SearchPostsEvent('Title 1'));
      await Future.delayed(const Duration(milliseconds: 600)); // debounce + margin
    },
    expect: () => [
      const PostLoading(),
      PostLoaded(posts),
      const PostLoading(),
      PostLoaded([posts[0]]),
    ],
  );
}

class TestFailure extends Failure {
  TestFailure(super.message);
}