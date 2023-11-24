// users_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users {
  String id;
  String captions;
  String photos;
  int like;
  String comment;
  List<String> likedBy;
  Users({
    required this.id,
    required this.captions,
    required this.photos,
    required this.like,
    required this.comment,
    required this.likedBy,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    var likedByList = json['likedBy'] as List?;
    List<String> likedBy = likedByList != null
        ? likedByList.map((e) => e.toString()).toList()
        : [];

    return Users(
      id: json['id'] ?? '',
      captions: json['captions'] ?? '',
      photos: json['photos'] ?? '',
      like: json['like'] ?? 0,
      comment: json['comment'] ?? '',
      likedBy: likedBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'captions': captions,
      'photos': photos,
      'like': like,
      'comment': comment,
      'likedBy': likedBy
    };
  }

  Future<String?> _getUserIdFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> updateLikes() async {
    try {
      final String? userId = await _getUserIdFromPreferences();

      if (userId != null) {
        if (likedBy.contains(userId)) {
          // User already liked the post, so dislike it
          likedBy.remove(userId);
          like--;

          // Update the 'likedBy' and 'like' fields in Firestore or your backend
          await _updateLikesInFirestore();
        } else {
          // User hasn't liked the post, so like it
          likedBy.add(userId);
          like++;

          // Update the 'likedBy' and 'like' fields in Firestore or your backend
          await _updateLikesInFirestore();
        }
      }
    } catch (e) {
      print('Error updating likes: $e');
    }
  }

  Future<void> _updateLikesInFirestore() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('images');

    await usersCollection.doc(id).update({
      'likedBy': likedBy,
      'like': like,
    });
  }

  Future<void> updateComment(String newComment) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('images');
    await usersCollection.doc(id).update({'comment': newComment});
  }
}
