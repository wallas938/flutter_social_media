/*
This page will display a tab bar to show:

- list of followers
- list of following

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/profile/presentation/components/user.tile.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.cubit.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,

      // SCAFFOLD
      child: Scaffold(
        // App Bar
        appBar: AppBar(
          // Tab Bar
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ), // TabBar
        ), // AppBar

        // Tab Bar View
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers", context),
            _buildUserList(following, "No following", context),
          ],
        ), // TabBarView
      ), // Scaffold
    ); // DefaultTabController
  }

  // build user list, given a list of profile uids
  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              // get each uid
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  // user loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTile(
                      user: user,
                    );
                  }

                  // loading..
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading.."));
                  }

                  // not found..
                  else {
                    return const ListTile(title: Text("User not found.."));
                  }
                },
              );
            }, // itemBuilder
          );
  }
}
