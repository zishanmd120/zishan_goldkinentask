import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Post #${post.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(post.title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text('Body', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(post.body, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text('User ID: ${post.userId}'),
            Text('Post ID: ${post.id}'),
          ],
        ),
      ),
    );
  }
}
