import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';
import 'package:dio/dio.dart';

abstract class AuthService {
  Future<ResultFuture<String>> getAuthToken();
}

class ApiConstants {
  static const String statusSuccess = 'success';
  static const String headerAuthKey = 'X-Auth-Key';
}

class _AuthServiceImpl implements AuthService {
  final Dio _dio;
  final String baseUrl;
  final String authKey;

  _AuthServiceImpl(
      {required Dio dio, required this.baseUrl, required this.authKey})
      : _dio = dio;

  @override
  Future<ResultFuture<String>> getAuthToken() async {
    return await safeExecute(() async {
      final response = await _dio.get(
        baseUrl,
        options: Options(headers: {ApiConstants.headerAuthKey: authKey}),
      );

      if (response.statusCode == 200 &&
          response.data['status'] == ApiConstants.statusSuccess) {
        return response.data['data']['auth_token'].toString();
      } else {
        throw Exception(response.data['message']);
      }
    });
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return _AuthServiceImpl(
    baseUrl: 'https://warp-registration.warpdir2792.workers.dev/',
    authKey: '3735928559',
    dio: Dio(),
  );
});
