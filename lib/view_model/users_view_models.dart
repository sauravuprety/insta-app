// users_view_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/user_model.dart';

class UsersViewModel {
  Stream<List<Users>> get usersStream =>
      FirebaseFirestore.instance.collection('images').snapshots().map(
            (event) =>
                event.docs.map((doc) => Users.fromJson(doc.data())).toList(),
          );
  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('images')
          .doc(postId)
          .delete();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> createUser(Users user) async {
    final docUser = FirebaseFirestore.instance.collection('images').doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }
}
