import 'package:codefactory/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  // 1. 요청을 보낼 때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // logger
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final refreshToken = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({'Authorization': 'Bearer $refreshToken'});
    }

    return super.onRequest(options, handler);
  }
  // 2. 요청을 받을 때

  // 3. 에러가 났을 때
}
