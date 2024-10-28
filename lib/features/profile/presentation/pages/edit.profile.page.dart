import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/presentation/components/my.text.field.dart';
import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.cubit.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

// web image pick
  Uint8List? webImage;

// bio text controller
  final bioTextController = TextEditingController();


  // update profile button pressed
  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
      );
    }
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // save button
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.upload),
          ), // IconButton
        ],
      ), // AppBar
      body: Column(
        children: [
          // profile picture

          // bio
          const Text("Bio"),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obscureText: false,
            ), // MyTextField
          ), // Padding
        ],
      ), // Column
    ); // Scaffold
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // profile loading..
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading..."),
                ],
              ),
            ), // Column
          ); // Scaffold
        } else {
          // edit form
          return buildEditPage();
        }
      },
      listener: (context, state) {},
    );
  }
}
