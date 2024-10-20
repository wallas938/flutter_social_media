import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';

abstract class AuthStates {}

// initial
class AuthInitial extends AuthStates {}

// loading
class AuthLoading extends AuthStates {}

// authenticated
class Authenticated extends AuthStates {
  final AppUser user;

  Authenticated({required this.user});
}

// unauthenticated
class Unauthenticated extends AuthStates {}

// Error
class AuthError extends AuthStates {
  final String message;

  AuthError({required this.message});
}
