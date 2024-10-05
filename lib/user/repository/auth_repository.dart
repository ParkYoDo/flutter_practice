import 'package:codefactory/common/model/login_response.dart';
import 'package:codefactory/common/model/token_response.dart';
import 'package:codefactory/common/utils/data_utils.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  // baseUrl : http://$ip/auth
  final String baseUrl;
  final Dio dio;

  AuthRepository({required this.baseUrl, required this.dio});

  Future<LoginResponse> login(
      {required String username, required String password}) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final res = await dio.post('$baseUrl/login',
        options: Options(headers: {'authorization': 'Basic $serialized'}));

    return LoginResponse.fromJson(res.data);
  }

  Future<TokenResponse> token() async {
    final res = await dio.post('$baseUrl/token',
        options: Options(headers: {'refreshToken': 'true'}));

    return TokenResponse.fromJson(res.data);
  }
}
