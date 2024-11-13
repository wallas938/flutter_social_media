import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';
import 'package:flutter_social_project/features/authentication/presentation/components/my.text.field.dart';
import 'package:flutter_social_project/features/authentication/presentation/cubits/auth.cubit.dart';
import 'package:flutter_social_project/features/post/domain/entities/comment.dart';
import 'package:flutter_social_project/features/post/domain/entities/post.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.cubit.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.states.dart';
import 'package:flutter_social_project/features/profile/domain/entities/profile.user.dart';
import 'package:flutter_social_project/features/profile/presentation/cubits/profile.cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

// current user
  AppUser? currentUser;

// post user
  ProfileUser? userProfile;

// on startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        userProfile = fetchedUser;
      });
    }
  }

/*
  LIKES
*/
  // user tapped like button
  void toggleLikePost() {
    // current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // optimistically like & update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // unlike
      } else {
        widget.post.likes.add(currentUser!.uid); // like
      }
    });

// update like
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      // if there's an error, revert back to original values
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // revert like
        } else {
          widget.post.likes.remove(currentUser!.uid); // revert unlike
        }
      });
    });

    // update like
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid);
  }

  /*
  COMMENTS
  */

  // comment text controller
  final commentTextController = TextEditingController();

// open comment box -> user wants to type a new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ), // MyTextField
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ), // TextButton

// save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ), // TextButton
        ],
      ), // AlertDialog
    );
  }

  // new comment request to postCubit
  void addComment() {
    // create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: widget.post.userId,
      userName: widget.post.userName,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    ); // Comment

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  // show delete post alert
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ), // TextButton

          // delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ), // TextButton
        ],
      ), // AlertDialog
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // Top section: profile pic / name / delete button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // profile pic
                userProfile?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: userProfile!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ), // Container
                      ) // CachedNetworkImage
                    : const Icon(Icons.person),

                const SizedBox(
                  width: 10,
                ),
                // name
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Text

                const Spacer(),
                // delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ), // Icon
                  ), // GestureDetector
              ],
            ),
          ),
          // image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // buttons -> like, comment, timestamp
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // like button
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.likes.contains(currentUser!.uid)
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ), // Icon
                ), // GestureDetector

                const SizedBox(width: 5),

                // like count
                Text(
                  widget.post.likes.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ), // TextStyle
                ), //

                const SizedBox(width: 20),
// comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ), // Icon
                ), // GestureDetector

                const SizedBox(width: 5),

                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ), // TextStyle
                ), // Text

                const Spacer(),

                // timestamp
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),

          // CAPTION
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Row(
                children: [
                  // username
                  Text(
                    widget.post.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ), // Text

                  const SizedBox(width: 10),

                  // text
                  Text(widget.post.text),
                ],
              )),

          // COMMENT SECTION
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // LOADED
              if (state is PostsLoaded) {
                // final individual post
                final post =
                    state.posts.firstWhere((post) => post.id == widget.post.id);

                if (post.comments.isNotEmpty) {
                  // how many comments to show
                  int showCommentCount = post.comments.length;

                  // comment section
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // get individual comment
                      final comment = post.comments[index];

                      // comment tile UI
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            // name
                            Text(
                              comment.userName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(width: 10),

                            // comment text
                            Text(comment.text),

                            const Spacer(),
                          ],
                        ),
                      );
                    },
                  ); // ListView.builder
                }
              }

              // LOADING..
              if (state is PostsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // ERROR
              else if (state is PostsError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(
                  child: Text("Something went wrong.."),
                ); // Center
              }
            },
          ),
        ],
      ),
    );
  }
}
