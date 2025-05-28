import 'package:dartz/dartz.dart';
import 'package:zishan_goldkinentask/features/post/data/models/post_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datsources/post_local_datasource.dart';
import '../datsources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDatasource postLocalDatasource;
  PostRepositoryImpl(this.remoteDataSource, this.postLocalDatasource,);

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final postsModelList = await remoteDataSource.fetchPosts();
      final posts = postsModelList.map((model) => model.toEntity()).toList();

      postLocalDatasource.cachePosts(postsModelList);

      return Right(posts);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> searchPosts(String query) async {
    try {
      final posts = (await remoteDataSource.fetchPosts())
              .map((model) => model.toEntity())
              .toList();

      final filtered = posts.where((post) {
        final lowerQuery = query.toLowerCase();
        return post.title.toLowerCase().contains(lowerQuery) ||
            post.body.toLowerCase().contains(lowerQuery);
      }).toList();

      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByUserId(int userId) async {
    try {
      final posts = (await remoteDataSource.fetchPosts())
              .map((model) => model.toEntity())
              .toList();

      final filtered = posts.where((post) => post.userId == userId).toList();

      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

}

