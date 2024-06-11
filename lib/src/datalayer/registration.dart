import 'package:ztc/src/exceptions/safe_execution.dart';
import 'package:dio/dio.dart';

abstract class IRegistrationAPI {
  Future<ResultFuture<String>> getAuthToken();
}

IRegistrationAPI buildApiClient({
  required String baseUrl,
  required String authKey,
  Dio? dio,
}) {
  return _RegistrationAPI(
    baseUrl: baseUrl,
    authKey: authKey,
    dio: dio ?? Dio(),
  );
}

class ApiConstants {
  static const String statusSuccess = 'success';
  static const String headerAuthKey = 'X-Auth-Key';
}

class _RegistrationAPI implements IRegistrationAPI {
  final Dio _dio;
  final String baseUrl;
  final String authKey;

  _RegistrationAPI(
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
