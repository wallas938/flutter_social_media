import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';
import 'package:flutter_social_project/features/profile/domain/repository/profile.repository.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.states.dart';
import 'package:flutter_social_project/features/storage/domain/storage.repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final StorageRepository storageRepository;

  ProfileCubit(
      {required this.profileRepository, required this.storageRepository})
      : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepository.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // return user profile given uid -> useful for loading many profiles for posts
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepository.fetchUserProfile(uid);
    return user;
  }

// update bio and or profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    String? imageMobilePath,
    Uint8List? imageWebBytes,
  }) async {
    emit(ProfileLoading());

    try {
      // fetch current profile first
      final currentUser = await profileRepository.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;

// ensure there is an image
      // for mobile
      if (imageMobilePath != null) {
        // upload
        imageDownloadUrl = await storageRepository.uploadProfileImageMobile(
            imageMobilePath, uid);
      }
      // for web
      else if (imageWebBytes != null) {
        // upload
        imageDownloadUrl =
            await storageRepository.uploadProfileImageWeb(imageWebBytes, uid);
      }

      if (imageDownloadUrl == null) {
        emit(ProfileError("Failed to upload image"));
        return;
      }
      // update new profile
      final updatedProfile = currentUser.copyWith(
          newBio: newBio ?? currentUser.bio,
          newProfileImageUrl: imageDownloadUrl);

      // update in repo
      await profileRepository.updateProfile(updatedProfile);

      // re-fetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}
