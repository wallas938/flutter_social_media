import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';

abstract class SearchRepository {
  Future<List<ProfileUser?>> searchUsers(String query);
}
