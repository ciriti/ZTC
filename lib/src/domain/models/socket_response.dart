import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'socket_response.freezed.dart';
part 'socket_response.g.dart';

@freezed
class SocketResponse with _$SocketResponse {
  @JsonSerializable(explicitToJson: true)
  const factory SocketResponse({
    required String status,
    String? message,
    ResponseData? data,
  }) = _SocketResponse;

  factory SocketResponse.fromJson(Map<String, dynamic> json) =>
      _$SocketResponseFromJson(json);
}

@freezed
class ResponseData with _$ResponseData {
  @JsonSerializable(explicitToJson: true)
  const factory ResponseData({
    @JsonKey(name: 'daemon_status') required String daemonStatus,
    String? message,
  }) = _ResponseData;

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);
}
