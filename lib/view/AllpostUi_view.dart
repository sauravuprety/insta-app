// text_fields.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/user_model.dart';
import '../view_model/users_view_models.dart';
import 'ReadPost_view.dart';

class TextFields extends StatefulWidget {
  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  final controllerName = TextEditingController();
  final viewModel = UsersViewModel();

  final picker = ImagePicker();
  late File _selectedImage = File('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Add Post'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Caption',
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              await _pickImage();
            },
            child: kIsWeb
                ? Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _selectedImage.path.isNotEmpty
                        ? Image.network(
                            _selectedImage.path,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : Center(child: Icon(Icons.photo_album)),
                  )
                : Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _selectedImage.path.isNotEmpty
                        ? Image.file(
                            _selectedImage,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : Center(child: Icon(Icons.photo_album)),
                  ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              AddCaption();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            child: const Text(
              'Create',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _createPost(Users user) {
    UsersViewModel().createUser(user);
    // Optionally, you might want to navigate back to the previous screen or update the UI
  }

  Future<void> AddCaption() async {
    final user = Users(
        captions: controllerName.text,
        photos: _selectedImage.path.isNotEmpty ? _selectedImage.path : '',
        like: 0,
        comment: '',
        id: '',
        likedBy: []);
    _createPost(user);
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => ReadUsers()));
  }

//function that pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
