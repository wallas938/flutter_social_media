import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/data/firebase.auth.repository.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.cubit.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.states.dart';
import 'package:flutter_social_project/features/authentication/presentation/pages/auth.page.dart';
import 'package:flutter_social_project/features/home/presentation/pages/home.page.dart';
import 'package:flutter_social_project/features/post/data/firebase.post.repository.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.cubit.dart';
import 'package:flutter_social_project/features/profile/data/firebase.profile.user.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.cubit.dart';
import 'package:flutter_social_project/features/storage/data/firebase.storage.repository.dart';
import 'package:flutter_social_project/themes/light.mode.dart';
/*
APP – Root Level
---------------------------------------------------

Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page (login/register)
  - authenticated -> home page
*/

class MyApp extends StatelessWidget {
  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepository();

// profile repo
  final firebaseProfileRepo = FirebaseProfileRepository();

  // post repo
  final firebasePostRepo = FirebasePostRepository();

// storage repo
  final firebaseStorageRepo = FirebaseStorageRepository();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepository: firebaseAuthRepo)..checkAuth(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(
              profileRepository: firebaseProfileRepo,
              storageRepository: firebaseStorageRepo),
        ),
        BlocProvider(
          create: (context) => PostCubit(
              fireBasePostRepository: firebasePostRepo,
              storageRepository: firebaseStorageRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            // unauthenticated -> auth page (login/register)
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            // authenticated -> home page
            if (authState is Authenticated) {
              return const HomePage();
            }

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          //listen for any server error
          listener: (context, authState) {
            // Add listener logic here if needed
            if (authState is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authState.message),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
