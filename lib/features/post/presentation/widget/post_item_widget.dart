import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';

class PostItemWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostItemWidget({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bodyPreview = post.body.length > 50 ? '${post.body.substring(0, 50)}...' : post.body;
    return ListTile(
      title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(bodyPreview, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}
