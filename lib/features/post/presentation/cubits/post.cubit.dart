import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/post/data/firebase.post.repository.dart';
import 'package:flutter_social_project/features/post/domain/entities/comment.dart';
import 'package:flutter_social_project/features/post/domain/entities/post.dart';
import 'package:flutter_social_project/features/post/presentation/cubits/post.states.dart';
import 'package:flutter_social_project/features/storage/domain/storage.repository.dart';

class PostCubit extends Cubit<PostState> {
  final FirebasePostRepository fireBasePostRepository;
  final StorageRepository storageRepository;

  PostCubit(
      {required this.fireBasePostRepository, required this.storageRepository})
      : super(PostsInitial());

  // create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      // handle image upload for mobile platforms (using file path)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl =
            await storageRepository.uploadPostImageMobile(imagePath, post.id);
      }

      // handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl =
            await storageRepository.uploadPostImageWeb(imageBytes, post.id);
      }

      // give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // create post in the backend
      fireBasePostRepository.createPost(newPost);

      fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await fireBasePostRepository.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // delete a post
  Future<void> deletePost(String postId) async {
    try {
      await fireBasePostRepository.deletePost(postId);
    } catch (e) {
      emit(PostsError("Failed to delete post: $e"));
    }
  }

  // toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await fireBasePostRepository.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  // add a comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await fireBasePostRepository.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

// delete comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await fireBasePostRepository.deleteComment(postId, commentId);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
