import '../../domain/entities/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required int userId,
    required int id,
    required String title,
    required String body,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  factory PostModel.fromEntity(Post post) => PostModel(
    userId: post.userId,
    id: post.id,
    title: post.title,
    body: post.body,
  );
}

extension PostModelX on PostModel {
  Post toEntity() {
    return Post(
      userId: userId,
      id: id,
      title: title,
      body: body,
    );
  }
}
