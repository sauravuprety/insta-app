import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../classfiles/UsersClass.dart';
import 'CreateDataForFirebase.dart';

class ReadUsers extends StatefulWidget {
  const ReadUsers({super.key});

  @override
  State<ReadUsers> createState() => _ReadUsersState();
}

class _ReadUsersState extends State<ReadUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('All Posts'),
      ),
      body: StreamBuilder<List<Users>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                return buildUsers(users[index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink, // Background color

        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TextFeilds()));
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.grey,
    );
  }

  Widget buildUsers(Users users) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              users.captions,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Image
          Image.network(
            users.photos,

            height: 300, // Adjust the height as needed
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Caption

          // Likes and Comments
          // Likes and Comments

          // Additional information (e.g., like button, comment button, etc.)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () async {
                      await users.updateLikes();
                      Text(users.like.toString());
                      // Refresh the UI by triggering a new snapshot
                      setState(() {
                        // Update the like count in the local Users instance
                        users.like = users.like + 1;
                      });
                    },
                  ),
                  const SizedBox(width: 2),
                  Text(users.like.toString()),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () async {
                  await _showCommentDialog(
                      users, context); // Pass the Users instance
                },
              ),
            ],
          ),
          Text("comment:" + users.comment)
        ],
      ),
    );
  }
  //shows popup dialog box to add comments

  Future<void> _showCommentDialog(Users users, BuildContext context) async {
    TextEditingController commentController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Enter your comment'),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, // Background color
              ),
              onPressed: () async {
                String newComment = commentController.text;
                if (newComment.isNotEmpty) {
                  await users.updateComment(newComment);
                  Navigator.of(context).pop();
                } else {
                  // Optionally, show an error message or handle empty comment
                }
              },
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

//read the data from firebase
  Stream<List<Users>> readUsers() =>
      FirebaseFirestore.instance.collection('images').snapshots().map(
            (event) =>
                event.docs.map((doc) => Users.fromJson(doc.data())).toList(),
          );
}
