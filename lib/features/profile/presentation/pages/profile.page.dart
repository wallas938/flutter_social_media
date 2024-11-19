import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.cubit.dart';
import 'package:flutter_social_project/features/post/presentation/components/post.tile.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.cubit.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.states.dart';
import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';
import 'package:flutter_social_project/features/profile/presentation/components/bio.box.dart';
import 'package:flutter_social_project/features/profile/presentation/components/follow.button.dart';
import 'package:flutter_social_project/features/profile/presentation/components/profile.stats.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.cubit.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.states.dart';
import 'package:flutter_social_project/features/profile/presentation/pages/edit.profile.page.dart';
import 'package:flutter_social_project/features/profile/presentation/pages/follower.page.dart';
import 'package:flutter_social_project/responsive/constrained.scaffold.dart';

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

  //posts
  int postCount = 0;

  //User Profile
  late ProfileUser profileUser;

// on startup,
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

/*
*
* Follow / unFollow Method
*
* */
  void followButtonPressed() {
    bool isFollowing = profileUser.followers.contains(currentUser!.uid);

    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    // perform actual toggle in cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      // revert update if there's an error
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        }
        // follow
        else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

// BUILD UI
  @override
  Widget build(BuildContext context) {
    bool isOwnPost = currentUser != null && widget.uid == currentUser!.uid;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          profileUser = state.profileUser;
          final isFollowing = profileUser.followers.contains(currentUser!.uid);

          return ConstrainedScaffold(
            // APP BAR
            appBar: AppBar(
              centerTitle: true,
              title: Text(profileUser.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                // edit profile button
                if (isOwnPost)
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          user: profileUser,
                        ),
                      ), // MaterialPageRoute
                    ),
                    icon: const Icon(Icons.settings),
                  ), // IconButton
              ],
            ), // AppBar

            // BODY
            body: ListView(
              children: [
                // email
                Center(
                  child: Text(
                    profileUser.email,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ), // Text

                const SizedBox(height: 25),

                BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                  if (state is PostsLoaded) {
                    return ProfileStats(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowerPage(
                            followers: profileUser.followers,
                            following: profileUser.following,
                          ),
                        ),
                      ),
                      postCount: state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList()
                          .length,
                      followerCount: profileUser.followers.length,
                      followingCount: profileUser.following.length,
                    );
                  }
                  return const Row(
                    children: [],
                  );
                }),

                // profile pic
                CachedNetworkImage(
                  imageUrl: profileUser.profileImageUrl,
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
                ),

                const SizedBox(height: 25),
                if (!isOwnPost)
                  FollowButton(
                    onPressed: followButtonPressed,
                    isFollowing: isFollowing,
                  ),

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
                ),

                const SizedBox(height: 10),

                BioBox(text: profileUser.bio),

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
                ),

                const SizedBox(height: 10),

                // list of posts from this user
                BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                  // posts loaded..
                  if (state is PostsLoaded) {
                    // filter posts by user id
                    final userPosts = state.posts
                        .where((post) => post.userId == widget.uid)
                        .toList();

                    postCount = userPosts.length;

                    return ListView.builder(
                      itemCount: postCount,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // get individual post
                        final post = userPosts[index];

                        // return as post tile UI
                        return PostTile(
                          post: post,
                          onDeletePressed: () =>
                              context.read<PostCubit>().deletePost(post.id),
                        ); // PostTile
                      },
                    );
                  }
                  //  posts loading..
                  else if (state is PostsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(
                      child: Text("No posts.."),
                    ); // Center

                    // posts loading..
                    // handle loading or error states if necessary
                  }
                })
              ],
            ),
          );
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
