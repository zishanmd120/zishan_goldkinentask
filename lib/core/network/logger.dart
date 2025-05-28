import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class DioLogger {
  void debugLog(Response response) {
    print("DEBUG: [${response.statusCode}] ${response.requestOptions.method} ${response.requestOptions.uri}");
    print("RESPONSE DATA: ${response.data}");
  }

  void logUrl(String message) {
    print("REQUEST URL: $message");
  }

  void errorLog(String message) {
    print("ERROR: $message");
  }

  void errorLogDio(DioException e) {
    print("DIO ERROR:");
    print("TYPE: ${e.type}");
    print("MESSAGE: ${e.message}");
    if (e.response != null) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
    }
  }
}

loggerDev(data) => developer.log(data);
