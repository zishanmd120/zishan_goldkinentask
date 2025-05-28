import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post.dart';

part 'post_state.freezed.dart';

@freezed
class PostState with _$PostState {
  const factory PostState.initial() = PostInitial;
  const factory PostState.loading() = PostLoading;
  const factory PostState.loaded(List<Post> posts) = PostLoaded;
  const factory PostState.error(String message) = PostError;
}
