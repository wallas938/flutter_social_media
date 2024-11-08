import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_project/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

// convert post -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

// convert json -> post
  factory Post.fromJson(Map<String, dynamic> json) {
    final comments = List<Map<String, dynamic>>.from(json['comments'] ?? [])
        .map((jsonComment) => Comment(
            id: jsonComment['id'],
            postId: jsonComment['postId'],
            userId: jsonComment['userId'],
            userName: jsonComment['userName'],
            text: jsonComment['text'],
            timestamp: (jsonComment['timestamp'] as Timestamp).toDate()))
        .toList();
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['name'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments,
    );
  }
}
