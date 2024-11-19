import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/profile/presentation/components/user.tile.dart';
import 'package:flutter_social_project/features/search/presentation/cubits/search.cubit.dart';
import 'package:flutter_social_project/features/search/presentation/cubits/search.states.dart';
import 'package:flutter_social_project/responsive/constrained.scaffold.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        // Search Text Field
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search users..",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ), // InputDecoration
        ), // TextField
      ), // AppBar

// Search Results
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no users..
            if (state.users.isEmpty) {
              return const Center(child: Text("No users found"));
            }

            // users..
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              },
            );
          }
          // loading..
          else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

// error..
          else if (state is SearchError) {
            return Center(child: Text(state.message));
          }

// default
          return const Center(
            child: Text("Start searching for users."),
          );
        },
      ),
    ); // Scaffold
  }
}
