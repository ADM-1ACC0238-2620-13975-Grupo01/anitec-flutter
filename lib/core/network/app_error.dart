import 'package:dio/dio.dart';

/// Failures the UI can react to.
///
/// Decided from the HTTP status (or the transport failure), never by parsing server text.
sealed class AppError {
  const AppError();
}

/// No connection, timeout or DNS failure.
final class NetworkError extends AppError {
  const NetworkError();
}

/// HTTP 401: missing, invalid or expired token.
final class UnauthorizedError extends AppError {
  const UnauthorizedError();
}

/// HTTP 403.
final class ForbiddenError extends AppError {
  const ForbiddenError();
}

/// HTTP 404.
final class NotFoundError extends AppError {
  const NotFoundError();
}

/// HTTP 409: duplicate resource.
final class ConflictError extends AppError {
  const ConflictError();
}

/// HTTP 400: the server rejected the input. The sign-in endpoint also answers wrong credentials this way.
final class ValidationError extends AppError {
  const ValidationError();
}

/// HTTP 5xx.
final class ServerError extends AppError {
  const ServerError(this.code);

  final int code;
}

/// Unexpected client-side or unmapped failure.
final class UnknownError extends AppError {
  const UnknownError([this.message]);

  final String? message;
}

/// Carries an [AppError] across layer boundaries.
class AppException implements Exception {
  const AppException(this.error);

  final AppError error;

  @override
  String toString() => 'AppException($error)';
}

/// Runs an API call and converts every failure into an [AppException].
Future<T> guardApi<T>(Future<T> Function() block) async {
  try {
    return await block();
  } on AppException {
    rethrow;
  } on DioException catch (e) {
    throw AppException(_fromDio(e));
  } catch (e) {
    throw AppException(UnknownError(e.toString()));
  }
}

AppError _fromDio(DioException e) {
  final status = e.response?.statusCode;
  if (status == null) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => const NetworkError(),
      _ => UnknownError(e.message),
    };
  }
  return switch (status) {
    400 => const ValidationError(),
    401 => const UnauthorizedError(),
    403 => const ForbiddenError(),
    404 => const NotFoundError(),
    409 => const ConflictError(),
    >= 500 && <= 599 => ServerError(status),
    _ => UnknownError('HTTP $status'),
  };
}
