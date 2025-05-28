import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {

  Future<Either<Failure, List<Post>>> getPosts();

  Future<Either<Failure, List<Post>>> searchPosts(String query);

  Future<Either<Failure, List<Post>>> getPostsByUserId(int userId);

}
