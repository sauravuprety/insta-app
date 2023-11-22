import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  final String captions;
  String photos;
  int like;
  String comment;

  Users(
      {this.id = '',
      required this.captions,
      required this.photos,
      required this.like,
      required this.comment});
  //creating data

  Map<String, dynamic> toJson() => {
        'id': id,
        'captions': captions,
        'photos': photos,
        'like': like,
        'comment': comment,
      };

  //read data from firebase
  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'] ?? '',
        captions: json['captions'] ?? 'No caption available',
        photos: json['photos'] ?? 'No Photo Available',
        like: json['like'] ?? '',
        comment: json['comment'] ?? 'No Comments Available',
      );
  //function that sends the likes in firebase
  Future<void> updateLikes() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('images');
    await usersCollection.doc(id).update({'like': like + 1});
  }

  //function that sends the comments in firebase
  Future<void> updateComment(String newComment) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('images');
    await usersCollection.doc(id).update({'comment': newComment});
  }
}
