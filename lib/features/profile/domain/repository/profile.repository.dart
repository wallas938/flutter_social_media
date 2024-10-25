/*
Profile Repository
*/


import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';

abstract class ProfileRepository {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updatedProfile);
}