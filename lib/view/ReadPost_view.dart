// read_users.dart

import 'package:flutter/material.dart';

import '../Model/user_model.dart';
import '../view_model/users_view_models.dart';
import 'AllpostUi_view.dart';
import 'postCard_view.dart';

class ReadUsers extends StatefulWidget {
  const ReadUsers({Key? key}) : super(key: key);

  @override
  State<ReadUsers> createState() => _ReadUsersState();
}

class _ReadUsersState extends State<ReadUsers> {
  final viewModel = UsersViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('All Posts'),
      ),
      body: StreamBuilder<List<Users>>(
        stream: viewModel.usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                return PostCard(users[index]);
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
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TextFields()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
