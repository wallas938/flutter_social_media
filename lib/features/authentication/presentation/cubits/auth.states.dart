import 'package:flutter/foundation.dart';
import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';

abstract class AuthStates {}

// initial
class AuthInitial extends AuthStates {
  AuthInitial() {
    if (kDebugMode) {
      print(AuthInitial);
    }
  }
}

// loading
class AuthLoading extends AuthStates {
  AuthLoading() {
    if (kDebugMode) {
      print(AuthLoading);
    }
  }
}

// authenticated
class Authenticated extends AuthStates {
  final AppUser user;

  Authenticated({required this.user}) {
    if (kDebugMode) {
      print(Authenticated);
    }
  }
}

// unauthenticated
class Unauthenticated extends AuthStates {
  Unauthenticated() {
    if (kDebugMode) {
      print(Unauthenticated);
    }
  }
}

// Error
class AuthError extends AuthStates {
  final String message;

  AuthError({required this.message}) {
    if (kDebugMode) {
      print(Unauthenticated);
    }
  }
}
