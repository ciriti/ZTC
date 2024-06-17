import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:ztc/src/application/services/auth_service.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthService authService;
  const baseUrl = 'https://warp-registration.warpdir2792.workers.dev/';
  const authKey = '3735928559';

  setUp(() {
    mockDio = MockDio();
    authService = authServiceFactory(
      dio: mockDio,
      baseUrl: baseUrl,
      authKey: authKey,
    );
  });

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: baseUrl));
  });

  group('AuthService', () {
    test('returns auth token on successful response', () async {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(path: baseUrl),
        statusCode: 200,
        data: {
          'status': ApiConstants.statusSuccess,
          'data': {'auth_token': 'test_token'},
        },
      );

      when(() => mockDio.get(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => response);

      // Act
      final result = await authService.getAuthToken();

      // Assert
      result.fold(
        (failure) => fail('Expected a token but got a failure'),
        (token) => expect(token, 'test_token'),
      );
    });

    test('throws exception on unsuccessful response', () async {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(path: baseUrl),
        statusCode: 400,
        data: {
          'status': 'error',
          'message': 'Invalid request',
        },
      );

      when(() => mockDio.get(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => response);

      // Act
      final result = await authService.getAuthToken();

      // Assert
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (token) {
          fail('Expected a failure but got a token');
        },
      );
    });
  });
}
