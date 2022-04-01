import 'package:flutter/material.dart';
import 'package:second_chance/models/Location.dart';
import 'models/UserModel.dart';
import 'dart:async';
import 'view_profile_page.dart';
import 'amplify.dart';

class LocationPage extends StatefulWidget {
  const LocationPage(
      {Key? key, required this.location, required this.amplifyState})
      : super(key: key);

  final Location location;
  final AmplifyState amplifyState;

  @override
  _LocationState createState() {
    return _LocationState(this.location, this.amplifyState);
  }
}

class _LocationState extends State<LocationPage> {
  final Location location;
  final AmplifyState amplifyState;
  _LocationState(this.location, this.amplifyState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(location.BarName.toString()),
        ),
        // bottomNavigationBar: menu(),
        body: _buildLocation());
  }

  Widget _buildLocation() {
    Future<List<UserModel>> allUsers = amplifyState.getAllUsersNM();
    return FutureBuilder<List<UserModel>>(
        future: allUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Text('None');
            }
            print(snapshot.data.toString());
            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: (snapshot.data!.length * 2),
                itemBuilder: (context, i) {
                  if (i.isOdd) {
                    return const Divider();
                  }

                  final index = i ~/ 2;
                  return _buildRow(context, snapshot.data![index]);
                });
          } else {
            return Container(
              child: Text('Loading'),
            );
          }
        });
  }

  Widget buildImage(UserModel user) {
    Future<String> userProfilePicUrl;
    userProfilePicUrl = amplifyState.getUserProfilePicture(user);
    return FutureBuilder(
        future: userProfilePicUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: NetworkImage(snapshot.data!.toString()),
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  child: InkWell(),
                ),
              ),
            );
          }
          return const Icon(Icons.person, color: Colors.black, size: 50);
        });
  }

  Widget _buildRow(BuildContext context, UserModel thisUser) {
    return Card(
        child: ListTile(
            leading: buildImage(thisUser),
            title: Text(
              thisUser.Name.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(thisUser.Gender.toString()),
            trailing:
                Icon(Icons.person_add_alt_1, color: Colors.black, size: 40),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewProfilePage(
                            viewUser: thisUser,
                            // location: location,
                            amplifyState: amplifyState,
                          )));
            }));
  }
}
