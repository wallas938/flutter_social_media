import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ProfileUser?> users;

  SearchLoaded(this.users);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
