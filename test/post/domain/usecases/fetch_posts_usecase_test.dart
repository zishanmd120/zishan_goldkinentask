import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zishan_goldkinentask/core/error/failures.dart';
import 'package:zishan_goldkinentask/features/post/domain/entities/post.dart';
import 'package:zishan_goldkinentask/features/post/domain/usecases/get_posts.dart';
import '../../data/mock_post_repository.mocks.dart';

void main() {
  late MockPostRepository mockRepo;
  late GetPosts useCase;

  final posts = [
    const Post(id: 1, userId: 1, title: "Title", body: "Body"),
  ];

  setUp(() {
    mockRepo = MockPostRepository();
    useCase = GetPosts(mockRepo);
  });

  test('should get posts from repository', () async {
    when(mockRepo.getPosts()).thenAnswer((_) async => Right(posts));

    final result = await useCase();

    expect(result.isRight(), true);
    result.fold(
          (_) => fail('Expected Right but got Left'),
          (postsList) {
        expect(postsList, posts);
      },
    );

    verify(mockRepo.getPosts()).called(1);
  });

  test('should return failure when repository fails', () async {
    when(mockRepo.getPosts()).thenAnswer((_) async => Left(TestFailure('Error')));

    final result = await useCase();

    expect(result.isLeft(), true);
    result.fold(
          (failure) => expect(failure.message, 'Error'),
          (_) => fail('Expected Left but got Right'),
    );

    verify(mockRepo.getPosts()).called(1);
  });
}

class TestFailure extends Failure {
  TestFailure(super.message);
}
