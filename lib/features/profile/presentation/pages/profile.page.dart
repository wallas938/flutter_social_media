import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.cubit.dart';
import 'package:flutter_social_project/features/profile/presentation/components/bio.box.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.cubit.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.states.dart';
import 'package:flutter_social_project/features/profile/presentation/pages/edit.profile.page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late final AppUser? currentUser = authCubit.currentUser;

// on startup,
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

// BUILD UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          final user = state.profileUser;

          return Scaffold(
            // APP BAR
            appBar: AppBar(
              centerTitle: true,
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                // edit profile button
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        user: user,
                      ),
                    ), // MaterialPageRoute
                  ),
                  icon: const Icon(Icons.settings),
                ), // IconButton
              ],
            ), // AppBar

            // BODY
            body: Column(
              children: [
                // email
                Text(
                  user.email,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ), // Text

                const SizedBox(height: 25),
                // profile pic
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  // loading..
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),

                  // error -> failed to load
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ), // Icon

                  // loaded
                  imageBuilder: (context, imageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ), // BoxDecoration
                  ), // Container
                ), // CachedNetworkImage

                const SizedBox(height: 25),

                // bio box
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ), // TextStyle
                      ), // Text
                    ],
                  ), // Row
                ), // Padding

                const SizedBox(height: 10),

                BioBox(text: user.bio),

                // posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ), // TextStyle
                      ), // Text
                    ],
                  ), // Row
                ), // Paddi
              ],
            ), // Center
          ); // Scaffold
        }

        // loading..
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ), // Center
          ); // Scaffold
        } else {
          return const Center(
            child: Text("No profile found.."),
          ); // Center
        }
      },
    );
  }
}
