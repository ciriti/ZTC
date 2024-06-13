import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/application/services/auth_service.dart';

part 'auth_service_provider.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) {
  return authServiceFactory(
    baseUrl: 'https://warp-registration.warpdir2792.workers.dev/',
    authKey:
        '3735928559', // TODO hide the authKey using the .env plugin https://pub.dev/packages/flutter_dotenv,
    dio: Dio(),
  );
}
