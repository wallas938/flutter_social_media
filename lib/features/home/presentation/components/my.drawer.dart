import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.cubit.dart';
import 'package:flutter_social_project/features/home/presentation/components/my.drawer.title.dart';
import 'package:flutter_social_project/features/profile/presentation/pages/profile.page.dart';
import 'package:flutter_social_project/features/search/presentation/pages/search.page.dart';
import 'package:flutter_social_project/features/settings/pages/setting.page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                // Icon
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              // home tile
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  // pop menu drawer
                  Navigator.of(context).pop();

                  // get current user
                  final userUid = authCubit.currentUser!.uid;

                  // navigate to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        uid: userUid,
                      ),
                    ),
                  );
                },
              ),

              // search tile
              MyDrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ), // MaterialPageRoute
                ),
              ), // MyDrawerTile

              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ), // MaterialPageRoute
                ),
              ),

              const Spacer(),

              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () => authCubit.logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
