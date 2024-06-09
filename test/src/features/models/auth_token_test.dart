import 'package:flutter_test/flutter_test.dart';
import 'package:ztc/src/models/auth_token.dart';

void main() {
  group('AuthToken', () {
    test('correctly serializes from JSON with data', () {
      const jsonResponse = {
        "status": "success",
        "data": {"auth_token": 245346444925233}
      };

      final authToken = AuthToken.fromJson(jsonResponse);

      expect(authToken.status, 'success');
      expect(authToken.message, null);
      expect(authToken.data, isNotNull);
      expect(authToken.data!.authToken, 245346444925233);
    });

    test('correctly serializes from JSON with error message', () {
      const jsonResponse = {
        "status": "error",
        "message": "Invalid authentication key"
      };

      final authToken = AuthToken.fromJson(jsonResponse);

      expect(authToken.status, 'error');
      expect(authToken.message, 'Invalid authentication key');
      expect(authToken.data, null);
    });

    test('correctly serializes from JSON with complex error message', () {
      const jsonResponse = {
        "status": "error",
        "message":
            "An active incident is currently affecting this API (ICDT-1234). Please consult our status page for more details: https://www.cloudflarestatus.com/"
      };

      final authToken = AuthToken.fromJson(jsonResponse);

      expect(authToken.status, 'error');
      expect(authToken.message,
          "An active incident is currently affecting this API (ICDT-1234). Please consult our status page for more details: https://www.cloudflarestatus.com/");
      expect(authToken.data, null);
    });

    test('correctly serializes to JSON with data', () {
      const authToken = AuthToken(
        status: 'success',
        message: null,
        data: AuthData(authToken: 245346444925233),
      );

      final json = authToken.toJson();

      print(json);

      expect(json['status'], 'success');
      expect(json['message'], null);
      expect(json['data'], isNotNull);
      expect(json['data']['auth_token'], 245346444925233);
    });

    test('correctly serializes to JSON with error message', () {
      const authToken = AuthToken(
        status: 'error',
        message: 'Invalid authentication key',
        data: null,
      );

      final json = authToken.toJson();

      expect(json['status'], 'error');
      expect(json['message'], 'Invalid authentication key');
      expect(json['data'], null);
    });

    test('correctly serializes to JSON with complex error message', () {
      const authToken = AuthToken(
        status: 'error',
        message:
            "An active incident is currently affecting this API (ICDT-1234). Please consult our status page for more details: https://www.cloudflarestatus.com/",
        data: null,
      );

      final json = authToken.toJson();

      expect(json['status'], 'error');
      expect(json['message'],
          "An active incident is currently affecting this API (ICDT-1234). Please consult our status page for more details: https://www.cloudflarestatus.com/");
      expect(json['data'], null);
    });
  });
}
