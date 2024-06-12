import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';

part 'auth_token_data_store_provider.g.dart';

@riverpod
AuthTokenDataStore authToken(AuthTokenRef ref) {
  return buildAuthTokenDataStore();
}
