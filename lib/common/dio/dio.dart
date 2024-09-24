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
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3. 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러 - 토근 재발급 후 api 재요청
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    // refreshToken이 없을때 에러 return
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // token을 갱신하는 api가 아니고 accessToken을 필요로하는 api 요청에서 에러가 났을때
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final res = await dio.post('http://$ip/auth/token',
            options:
                Options(headers: {'Authorization': "Bearer $refreshToken"}));

        final accessToken = res.data['accessToken'];

        final options = err.requestOptions;

        // 토근 변경하기
        options.headers.addAll({'Authorization': 'Bearer $accessToken'});
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }
    // refreshToken을 갱신하거나 api status가 401이 아닐때
    return handler.reject(err);
  }
}
