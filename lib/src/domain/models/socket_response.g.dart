// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocketResponseImpl _$$SocketResponseImplFromJson(Map<String, dynamic> json) =>
    _$SocketResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SocketResponseImplToJson(
        _$SocketResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

_$ResponseDataImpl _$$ResponseDataImplFromJson(Map<String, dynamic> json) =>
    _$ResponseDataImpl(
      daemonStatus: json['daemon_status'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ResponseDataImplToJson(_$ResponseDataImpl instance) =>
    <String, dynamic>{
      'daemon_status': instance.daemonStatus,
      'message': instance.message,
    };
