import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as di;
import 'features/post/presentation/bloc/post_bloc.dart';
import 'features/post/presentation/pages/post_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(
            getPosts: di.sl(),
            searchPosts: di.sl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Zishan\'s Posts App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const PostListPage(),
      ),
    );
  }
}
