import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';
import 'package:flutter_social_project/features/authentication/domain/repository/auth.repository.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository authRepository;
  AppUser? _currentUser;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  // check if user is already authenticated
  void checkAuth() async {
    AppUser? user = await authRepository.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  // login with email + password
  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      AppUser? user =
          await authRepository.loginWithEmailPassword(email, password);

      if (user != null) {
        emit(Authenticated(user: user));
        _currentUser = user;
        return;
      }
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));

      emit(Unauthenticated());
    }
  }

  // Register a new user
  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());

    try {
      AppUser? user =
          await authRepository.registerWithEmailPassword(name, email, password);

      if (user != null) {
        emit(Authenticated(user: user));
        _currentUser = user;
        return;
      }
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout
  Future<void> logout() async {
    authRepository.logout();
    emit(Unauthenticated());
  }
}
