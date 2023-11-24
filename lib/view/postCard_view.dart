import 'package:flutter/material.dart';

import '../Model/user_model.dart';
import '../view_model/users_view_models.dart';

class PostCard extends StatefulWidget {
  final Users user;

  const PostCard(this.user);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  TextEditingController commentController = TextEditingController();
  //for deleting post
  void _deletePost(String postId) {
    UsersViewModel().deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.user.captions,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deletePost(widget.user.id);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete Post'),
                    ),
                  ),

                  // Add more options if needed
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Container(
            alignment: Alignment.center,
            child: Image.network(
              widget.user.photos,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: isLiked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ) // Filled heart icon
                        : const Icon(Icons.favorite_border),
                    onPressed: () async {
                      setState(() {
                        isLiked = !isLiked;
                      });
                      await widget.user.updateLikes();
                    },
                  ),
                  const SizedBox(width: 2),
                  Text(widget.user.like.toString()),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Write a comment...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  String newComment = commentController.text;
                  if (newComment.isNotEmpty) {
                    await widget.user.updateComment(newComment);

                    setState(() {
                      commentController.clear();
                    });
                  } else {}
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.user.comment),
        ),
        const Divider(
          height: 5,
          thickness: 0.5,
          color: Colors.black,
        ),
      ],
    );
  }
}
