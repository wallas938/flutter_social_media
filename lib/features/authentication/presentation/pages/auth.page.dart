/*
Auth Page – This page determines whether to show the login or register page
*/

import 'package:flutter/material.dart';
import 'package:flutter_social_project/features/authentication/presentation/pages/login.page.dart';
import 'package:flutter_social_project/features/authentication/presentation/pages/register.page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // initially, show login page
  bool showLoginPage = true;

  // toggle between pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        togglePages: togglePages,
      );
    } else {
      // return your register page or any other page here
      return RegisterPage(
        togglePages: togglePages,
      ); // Placeholder for the register page or other content
    }
  }
}
