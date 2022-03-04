import 'package:flutter/material.dart';
import 'main.dart';
import 'models/UserModel.dart';
import 'amplify.dart';
import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'match_page.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({Key? key, required this.location}) : super(key: key);

  final String location;

  Future<List<UserModel>> getAllUsers() async {
    try {
      List<UserModel> allUsers =
          await Amplify.DataStore.query(UserModel.classType);

      return (allUsers);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
      ),
      body: _buildLocation(),
    );
  }

  Widget _buildLocation() {
    Future<List<UserModel>> allUsers = getAllUsers();
    return FutureBuilder<List<UserModel>>(
        future: allUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            print(snapshot.data.toString());
            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: (snapshot.data!.length * 2),
                itemBuilder: (context, i) {
                  if (i.isOdd) {
                    return const Divider();
                  }

                  final index = i ~/ 2;
                  return _buildRow(
                      context, snapshot.data![index].Name.toString());
                });
          } else {
            return Container(
              child: Text('Loading'),
            );
          }
        });
  }

  Widget _buildRow(BuildContext context, String title) {
    return ListTile(
        title: Text(title),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MatchPage()));
        });
  }
}
