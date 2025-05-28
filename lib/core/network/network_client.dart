import 'dart:async';
import 'package:dio/dio.dart';

import 'logger.dart';
import 'network_response.dart';

class NetworkClient {
  final Dio _dio;
  final _logger = DioLogger();

  NetworkClient()
      : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'Accept': 'application/json',
    },
  ));

  Future<NetworkResponse<dynamic>> get({
    required String endpoint,
    String token = "",
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
          },
        ),
      );

      _logger.logUrl(endpoint);
      _logger.debugLog(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse.withSuccess(
          response.data,
          "success",
          response.statusCode ?? 200,
        );
      } else {
        return NetworkResponse.withFailure("error", response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      _logger.errorLog(e.message ?? "DioException");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return NetworkResponse.withFailure("Unable to connect the server.", 408);
      }

      return NetworkResponse.withFailure("Something went wrong.", e.response?.statusCode ?? 503);
    } catch (error) {
      _logger.errorLog(error.toString());
      return NetworkResponse.withFailure("Something went wrong.", 503);
    }
  }
}
