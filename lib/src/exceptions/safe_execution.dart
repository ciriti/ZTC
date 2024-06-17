import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

/// A base class representing a failure.
/// Extends [Equatable] to support value comparison.
///
/// [message] provides a description of the failure.
/// [code] is an optional error code.
/// [exception] is an optional [Exception] associated with the failure.
/// [error] is an optional error object.
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final Exception? exception;
  final Object? error;
  const Failure({
    required this.message,
    this.code,
    this.exception,
    this.error,
  });

  @override
  String toString() {
    return 'Failure(message: $message, code: $code, exception: $exception, error: $error)';
  }

  @override
  List<Object?> get props => [message, code, exception, error];
}

/// A class representing an API failure, extending [Failure].
class ApiFailure extends Failure {
  const ApiFailure({
    required super.message,
    super.code,
    super.exception,
    super.error,
  });
}

/// A class representing a generic failure, extending [Failure].
class GenericFailure extends Failure {
  const GenericFailure({
    required super.message,
    super.code,
    super.exception,
    super.error,
  });
}

/// A type alias for a future that returns either a [Failure] or a result of type [T].
typedef ResultFuture<T> = Either<Failure, T>;

/// Executes a given asynchronous function [expression] and returns a [ResultFuture].
///
/// If the function completes successfully, the result is wrapped in [Right].
/// If an exception is thrown, it is wrapped in [Left] as an [ApiFailure].
Future<ResultFuture<T>> safeExecute<T>(
  Future<T> Function() expression,
) async {
  try {
    final result = await expression();
    return Right(result);
  } on Exception catch (e) {
    return left(ApiFailure(exception: e, message: e.toString()));
  } catch (e) {
    return left(ApiFailure(message: e.toString(), error: e));
  }
}
