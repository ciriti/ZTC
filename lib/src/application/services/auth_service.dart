import 'package:ztc/src/exceptions/safe_execution.dart';
import 'package:dio/dio.dart';

/// An abstract class for handling authentication services.
///
/// The `AuthService` class provides a method for obtaining an authentication token.
/// Implementations of this class should provide the actual logic for fetching the token.
abstract class AuthService {
  /// Fetches an authentication token.
  ///
  /// Returns a `ResultFuture` which is either a `Failure` or a `String` representing the token.
  Future<ResultFuture<String>> getAuthToken();
}

/// A class containing constants for API responses and headers.
class ApiConstants {
  static const String statusSuccess = 'success';
  static const String headerAuthKey = 'X-Auth-Key';
}

/// A factory function for creating an instance of `AuthService`.
///
/// [dio] is the Dio instance used for making HTTP requests.
/// [baseUrl] is the base URL for the authentication API.
/// [authKey] is the authentication key used in the request headers.
AuthService authServiceFactory({
  required Dio dio,
  required String baseUrl,
  required String authKey,
}) {
  return _AuthServiceImpl(
    baseUrl: baseUrl,
    authKey: authKey,
    dio: dio,
  );
}

/// An implementation of `AuthService` that uses the Dio library for HTTP requests.
class _AuthServiceImpl implements AuthService {
  final Dio _dio;
  final String baseUrl;
  final String authKey;

  _AuthServiceImpl(
      {required Dio dio, required this.baseUrl, required this.authKey})
      : _dio = dio;

  /// Fetches an authentication token from the API.
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
