import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/logger.dart';
import 'core/network/network_client.dart';
import 'features/post/data/datsources/post_local_datasource.dart';
import 'features/post/data/datsources/post_remote_data_source.dart';
import 'features/post/data/repositories/post_repository_impl.dart';
import 'features/post/domain/repositories/post_repository.dart';
import 'features/post/domain/usecases/get_posts.dart';
import 'features/post/domain/usecases/search_posts.dart';
import 'features/post/presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => PostBloc(
    getPosts: sl(),
    searchPosts: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => SearchPosts(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(
      sl<PostRemoteDataSource>(),
      sl<PostLocalDatasource>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
        () => PostRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PostLocalDatasource>(
        () => PostLocalDatasourceImpl(sl<SharedPreferences>()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => NetworkClient());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioLogger());
}
