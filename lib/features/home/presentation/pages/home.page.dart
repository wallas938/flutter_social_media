import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/home/presentation/components/my.drawer.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("H O M E"),
        actions: [
          // logout button
          IconButton(
              onPressed: () {
                authCubit.logout();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}
