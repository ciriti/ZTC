import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/application/services/auth_service.dart';

part 'auth_service_provider.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) {
  return authServiceFactory();
}
