import 'package:dartz/dartz.dart';

import 'package:zishan_goldkinentask/core/error/failures.dart';

import '../entities/post.dart';
import '../repositories/post_repository.dart';

class SearchPosts {
  final PostRepository repository;

  SearchPosts(this.repository);

  Future<Either<Failure, List<Post>>> call(String query) async {
    return await repository.searchPosts(query);
  }
}