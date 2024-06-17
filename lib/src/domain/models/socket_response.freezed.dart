// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SocketResponse _$SocketResponseFromJson(Map<String, dynamic> json) {
  return _SocketResponse.fromJson(json);
}

/// @nodoc
mixin _$SocketResponse {
  String get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  ResponseData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocketResponseCopyWith<SocketResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocketResponseCopyWith<$Res> {
  factory $SocketResponseCopyWith(
          SocketResponse value, $Res Function(SocketResponse) then) =
      _$SocketResponseCopyWithImpl<$Res, SocketResponse>;
  @useResult
  $Res call({String status, String? message, ResponseData? data});

  $ResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$SocketResponseCopyWithImpl<$Res, $Val extends SocketResponse>
    implements $SocketResponseCopyWith<$Res> {
  _$SocketResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ResponseData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ResponseDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $ResponseDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SocketResponseImplCopyWith<$Res>
    implements $SocketResponseCopyWith<$Res> {
  factory _$$SocketResponseImplCopyWith(_$SocketResponseImpl value,
          $Res Function(_$SocketResponseImpl) then) =
      __$$SocketResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String? message, ResponseData? data});

  @override
  $ResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$SocketResponseImplCopyWithImpl<$Res>
    extends _$SocketResponseCopyWithImpl<$Res, _$SocketResponseImpl>
    implements _$$SocketResponseImplCopyWith<$Res> {
  __$$SocketResponseImplCopyWithImpl(
      _$SocketResponseImpl _value, $Res Function(_$SocketResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_$SocketResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ResponseData?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SocketResponseImpl
    with DiagnosticableTreeMixin
    implements _SocketResponse {
  const _$SocketResponseImpl({required this.status, this.message, this.data});

  factory _$SocketResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocketResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String? message;
  @override
  final ResponseData? data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SocketResponse(status: $status, message: $message, data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SocketResponse'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocketResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, message, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocketResponseImplCopyWith<_$SocketResponseImpl> get copyWith =>
      __$$SocketResponseImplCopyWithImpl<_$SocketResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocketResponseImplToJson(
      this,
    );
  }
}

abstract class _SocketResponse implements SocketResponse {
  const factory _SocketResponse(
      {required final String status,
      final String? message,
      final ResponseData? data}) = _$SocketResponseImpl;

  factory _SocketResponse.fromJson(Map<String, dynamic> json) =
      _$SocketResponseImpl.fromJson;

  @override
  String get status;
  @override
  String? get message;
  @override
  ResponseData? get data;
  @override
  @JsonKey(ignore: true)
  _$$SocketResponseImplCopyWith<_$SocketResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) {
  return _ResponseData.fromJson(json);
}

/// @nodoc
mixin _$ResponseData {
  @JsonKey(name: 'daemon_status')
  String get daemonStatus => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResponseDataCopyWith<ResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseDataCopyWith<$Res> {
  factory $ResponseDataCopyWith(
          ResponseData value, $Res Function(ResponseData) then) =
      _$ResponseDataCopyWithImpl<$Res, ResponseData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'daemon_status') String daemonStatus, String? message});
}

/// @nodoc
class _$ResponseDataCopyWithImpl<$Res, $Val extends ResponseData>
    implements $ResponseDataCopyWith<$Res> {
  _$ResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daemonStatus = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      daemonStatus: null == daemonStatus
          ? _value.daemonStatus
          : daemonStatus // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponseDataImplCopyWith<$Res>
    implements $ResponseDataCopyWith<$Res> {
  factory _$$ResponseDataImplCopyWith(
          _$ResponseDataImpl value, $Res Function(_$ResponseDataImpl) then) =
      __$$ResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'daemon_status') String daemonStatus, String? message});
}

/// @nodoc
class __$$ResponseDataImplCopyWithImpl<$Res>
    extends _$ResponseDataCopyWithImpl<$Res, _$ResponseDataImpl>
    implements _$$ResponseDataImplCopyWith<$Res> {
  __$$ResponseDataImplCopyWithImpl(
      _$ResponseDataImpl _value, $Res Function(_$ResponseDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daemonStatus = null,
    Object? message = freezed,
  }) {
    return _then(_$ResponseDataImpl(
      daemonStatus: null == daemonStatus
          ? _value.daemonStatus
          : daemonStatus // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ResponseDataImpl with DiagnosticableTreeMixin implements _ResponseData {
  const _$ResponseDataImpl(
      {@JsonKey(name: 'daemon_status') required this.daemonStatus,
      this.message});

  factory _$ResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponseDataImplFromJson(json);

  @override
  @JsonKey(name: 'daemon_status')
  final String daemonStatus;
  @override
  final String? message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResponseData(daemonStatus: $daemonStatus, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ResponseData'))
      ..add(DiagnosticsProperty('daemonStatus', daemonStatus))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseDataImpl &&
            (identical(other.daemonStatus, daemonStatus) ||
                other.daemonStatus == daemonStatus) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, daemonStatus, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseDataImplCopyWith<_$ResponseDataImpl> get copyWith =>
      __$$ResponseDataImplCopyWithImpl<_$ResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponseDataImplToJson(
      this,
    );
  }
}

abstract class _ResponseData implements ResponseData {
  const factory _ResponseData(
      {@JsonKey(name: 'daemon_status') required final String daemonStatus,
      final String? message}) = _$ResponseDataImpl;

  factory _ResponseData.fromJson(Map<String, dynamic> json) =
      _$ResponseDataImpl.fromJson;

  @override
  @JsonKey(name: 'daemon_status')
  String get daemonStatus;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$ResponseDataImplCopyWith<_$ResponseDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
