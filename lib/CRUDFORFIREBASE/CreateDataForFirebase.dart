import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../classfiles/UsersClass.dart';
import 'ReadfromFirebase.dart';

class TextFeilds extends StatefulWidget {
  @override
  State<TextFeilds> createState() => _TextFeildsState();
}

class _TextFeildsState extends State<TextFeilds> {
  final controllerName = TextEditingController();
  final picker = ImagePicker();
  late File _selectedImage = File("path"); // Provide an initial value

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
          //field where the caption is written
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
                    child: _selectedImage != null
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
                    child: _selectedImage != null
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
          //button that pass the data to the firebase

          Container(
            child: ElevatedButton(
              onPressed: () {
                AddCaption();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, // Background color
              ),
              child: const Text(
                'Create',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> AddCaption() async {
    final user = Users(
        captions: controllerName.text,
        photos: _selectedImage != null ? _selectedImage!.path : '',
        like: 0,
        comment: '');
    createUser(user);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ReadUsers()));

    // Background color

    // // try {
    // //   FirebaseStorage _storage = FirebaseStorage.instance;

    // //   // Create a reference to the location you want to upload to in Firebase Storage
    // //   firebase_storage.Reference reference = _storage
    // //       .ref()
    // //       .child("images/${DateTime.now().millisecondsSinceEpoch}");

    // //   // Upload the file to Firebase Storage
    // //   firebase_storage.UploadTask uploadTask =
    // //       reference.putFile(_selectedImage);

    // //   // Wait till the file is uploaded, then get the download URL
    // //   String imageUrl = await (await uploadTask).ref.getDownloadURL();

    //   // Create a user object with the image URL
    //   final user = Users(
    //     captions: controllerName.text,
    //     photos: _selectedImage,
    //     like: 0,
    //     comment:
    //         "", // You might want to update this to the actual comment value
    //   );

    //   // Save user data to Firestore
    //   createUser(user);

    //   // Navigate to the ReadUsers screen
    //   Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => ReadUsers()));
    // // } catch (ex) {
    // //   print(ex.toString());
    // // }
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

//function to pass data to firebase through id
Future<void> createUser(Users user) async {
  final docUser = FirebaseFirestore.instance.collection('images').doc();
  user.id = docUser.id;
  final json = user.toJson();
  await docUser.set(json);
}
