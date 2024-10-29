import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_project/features/posts/domain/entities/post.dart';
import 'package:flutter_social_project/features/posts/domain/repository/post.repository.dart';

class FirebaseRepository implements PostRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// store the posts in a collection called 'posts'
  final CollectionReference postsCollection =
  FirebaseFirestore.instance.collection('posts');


  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }


  @override
  Future<List<Post>> fetchAllPosts() {
    // TODO: implement fetchAllPosts
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) {
    // TODO: implement fetchPostsByUserId
    throw UnimplementedError();
  }
}