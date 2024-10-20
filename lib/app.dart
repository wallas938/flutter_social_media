import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/data/firebase.auth.repository.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.cubit.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.states.dart';
import 'package:flutter_social_project/features/authentication/presentation/pages/auth.page.dart';
import 'package:flutter_social_project/features/post/presentation/pages/home.page.dart';
import 'package:flutter_social_project/themes/light.mode.dart';
import 'package:get_it/get_it.dart';

class MyApp extends StatelessWidget {
  // auth repo
  final authRepo = FirebaseAuthRepository();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AuthCubit(authRepository: authRepo)
        ..checkAuth(),
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

            // loading...
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, authState) {
            // Add listener logic here if needed
          },
        ),
      ),
    );
  }
}