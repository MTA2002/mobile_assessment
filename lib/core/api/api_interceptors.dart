import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // Add user agent
    options.headers['User-Agent'] = 'CountriesApp/1.0.0';

    // Add any authentication tokens here if needed
    // Example: options.headers['Authorization'] = 'Bearer $token';

    if (kDebugMode) {
      debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      debugPrint('ERROR MESSAGE: ${err.message}');
    }

    super.onError(err, handler);
  }
}
