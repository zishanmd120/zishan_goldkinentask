import '../../../../core/network/network_client.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final NetworkClient dioClient;
  PostRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<PostModel>> fetchPosts() async {
    final response = await dioClient.get(endpoint: 'https://jsonplaceholder.typicode.com/posts',);

    if (response.status == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}
