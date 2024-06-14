import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

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

class ApiFailure extends Failure {
  const ApiFailure({
    required super.message,
    super.code,
    super.exception,
    super.error,
  });
}

class GenericFailure extends Failure {
  const GenericFailure({
    required super.message,
    super.code,
    super.exception,
    super.error,
  });
}

typedef ResultFuture<T> = Either<Failure, T>;

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
