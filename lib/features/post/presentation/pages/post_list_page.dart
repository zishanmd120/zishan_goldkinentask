import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../bloc/post_state.dart';
import '../widget/post_item_widget.dart';
import 'post_detail_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final _searchController = TextEditingController();
  int? _filterUserId;

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPostsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<PostBloc>().add(SearchPostsEvent(_searchController.text));
  }

  void _showFilterDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filter by userId'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter userId (number)',
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final val = int.tryParse(controller.text);
                if (val != null) {
                  setState(() {
                    _filterUserId = val;
                  });
                  context.read<PostBloc>().add(FilterPostsByUserIdEvent(val));
                }
                Navigator.pop(ctx);
              },
              child: const Text('Apply'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _filterUserId = null;
                });
                context.read<PostBloc>().add(FetchPostsEvent());
                Navigator.pop(ctx);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Posts'),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by UserId',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PostBloc>().add(FetchPostsEvent());
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _onSearchChanged(),
                decoration: const InputDecoration(
                  labelText: 'Search posts',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onTapOutside: (value){
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(child: Text('Start searching or refresh to load posts')),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (posts) {
                      if (posts.isEmpty) {
                        return const Center(child: Text('No posts found'));
                      }
                      return ListView.separated(
                        itemCount: posts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostItemWidget(
                            post: post,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PostDetailPage(post: post),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    error: (msg) => Center(child: Text('Error: $msg')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
