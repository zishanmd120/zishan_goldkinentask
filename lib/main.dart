import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold kinen Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PostListScreen(),
    );
  }
}

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; FlutterApp/1.0)',
        'Accept': 'application/json',
      },
    ),
  );

  List<PostListResponse> postListResponse = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchData();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Post List',),),
        body: isLoading ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
          itemCount: postListResponse.length,
          itemBuilder: (context, index){
            var item = postListResponse[index];
            return ListTile(
              title: Text(item.title ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,),
              subtitle: Text(item.body ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsScreen(
                  postId: item.id ?? 0,
                ),),);
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    String url = 'https://jsonplaceholder.typicode.com/posts';
    try {
      Response res = await _dio.get(url,);
      print('Status Code: ${res.statusCode}');
      print('Data: ${res.data}');
      print(res.statusCode);
      if(res.statusCode == 200){
        List<dynamic> jsonList = res.data;
        postListResponse = jsonList
            .map((json) => PostListResponse.fromJson(json))
            .toList();
        print(postListResponse);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

}

class PostDetailsScreen extends StatefulWidget {
  final int postId;
  const PostDetailsScreen({super.key, required this.postId,});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; FlutterApp/1.0)',
        'Accept': 'application/json',
      },
    ),
  );

  PostListResponse ? postListResponse;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dio GET Example',),),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          children: [
            Text("${postListResponse?.id ?? 0}"),
            Text("${postListResponse?.title ?? 0}"),
            Text("${postListResponse?.body ?? 0}"),
            Text("${postListResponse?.userId ?? 0}"),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData(int postId) async {
    setState(() {
      isLoading = true;
    });
    String url = 'https://jsonplaceholder.typicode.com/posts/$postId';
    try {
      Response res = await _dio.get(url,);
      print('Status Code: ${res.statusCode}');
      print('Data: ${res.data}');
      print(res.statusCode);
      if(res.statusCode == 200){
        postListResponse = PostListResponse.fromJson(res.data);
        print(postListResponse);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

}

class PostListResponse {
  int? userId;
  int? id;
  String? title;
  String? body;

  PostListResponse({this.userId, this.id, this.title, this.body});

  PostListResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}