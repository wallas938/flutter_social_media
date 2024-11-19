import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/home/presentation/components/my.drawer.dart';
import 'package:flutter_social_project/features/post/presentation/components/post.tile.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.cubit.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.states.dart';
import 'package:flutter_social_project/features/post/presentation/pages/upload.post.page.dart';
import 'package:flutter_social_project/responsive/constrained.scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// post cubit
  late final postCubit = context.read<PostCubit>();

// on startup
  @override
  void initState() {
    super.initState();

    // fetch all posts
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("H O M E"),
        actions: [
          // upload new post button
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadPostPage(),
              ), // MaterialPageRoute
            ),
            icon: const Icon(Icons.add),
          ), // IconButton
        ],
      ),
      drawer: const MyDrawer(),

      // BODY
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // loading..
          if (state is PostsLoading && state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(child: Text("No posts available"));
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                // get individual post
                final post = allPosts[index];
                // image
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                ); // CachedNetworkImage
              },
            ); // L
          }

          // error
          else if (state is PostsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ), // BlocBuilder
    );
  }
}
