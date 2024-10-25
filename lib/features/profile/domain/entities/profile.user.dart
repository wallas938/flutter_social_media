import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.name,
    required super.email,
    required this.bio,
    required this.profileImageUrl,
  });

  // method to update profile user
  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
        uid: uid,
        name: name,
        email: email,
        bio: newBio ?? bio,
        profileImageUrl: newProfileImageUrl ?? profileImageUrl);
  }

  // convert profile user -> json
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl
    };
  }

// convert json -> profile user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        bio: json['bio'] ?? '',
        profileImageUrl: json['profileImageUrl'] ?? '');
  }
}
