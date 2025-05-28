import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';

abstract class PostLocalDatasource {

  Future<void> cachePosts(List<PostModel> posts);

  Future<List<PostModel>> getCachePosts();

}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final SharedPreferences preferences;
  PostLocalDatasourceImpl(this.preferences);

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    final prefs = await SharedPreferences.getInstance();

    final postListJson = posts.map((post) => post.toJson()).toList();

    prefs.setString('cached_posts', json.encode(postListJson));
    print("cached_posts: ${prefs.getString('cached_posts')}");
  }

  @override
  Future<List<PostModel>> getCachePosts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cached_posts');

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
