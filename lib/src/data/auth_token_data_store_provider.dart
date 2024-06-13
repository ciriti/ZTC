import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';
import 'package:ztc/src/utils/ext.dart';

part 'auth_token_data_store_provider.g.dart';

@riverpod
AuthTokenDataStore authToken(AuthTokenRef ref) {
  return buildAuthTokenDataStore(
    isTimestampExpired: isTimestampExpired,
    tokenValidityDuration: 5,
  );
}
