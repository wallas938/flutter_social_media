/*
PROFILE STATES
*/

import 'package:flutter/foundation.dart';
import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';

abstract class ProfileState {}

// initial
class ProfileInitial extends ProfileState {
  ProfileInitial() {
    if (kDebugMode) {
      print(ProfileInitial);
    }
  }
}

// loading..
class ProfileLoading extends ProfileState {}

// loaded
class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;

  ProfileLoaded(this.profileUser) {
    if (kDebugMode) {
      print(ProfileLoaded);
    }
  }
}

// error
class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message) {
    if (kDebugMode) {
      print(ProfileError);
    }
  }
}
