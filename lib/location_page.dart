import 'package:flutter/material.dart';
import 'package:second_chance/models/Location.dart';
import 'models/UserModel.dart';
import 'dart:async';
import 'match_page.dart';
import 'view_profile_page.dart';
import 'messaging_page.dart';
import 'profile_page.dart';
import 'amplify.dart';

class LocationPage extends StatelessWidget {
  const LocationPage(
      {Key? key, required this.location, required this.amplifyState})
      : super(key: key);

  final Location location;
  final AmplifyState amplifyState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                  title: Text(location.BarName.toString()),
                  bottom: const TabBar(
                    tabs: [
                      Tab(
                        // text: "Locations",
                        icon: Icon(Icons.location_on_sharp),
                      ),
                      Tab(
                        // text: "Matches",
                        icon: Icon(Icons.social_distance_outlined),
                      ),
                      Tab(
                        // text: "Messages",
                        icon: Icon(Icons.messenger_rounded),
                      ),
                      Tab(
                        // text: "Profile",
                        icon: Icon(Icons.settings_accessibility),
                      ),
                    ],
                  ),
                ),
                // bottomNavigationBar: menu(),
                body: TabBarView(children: [
                  _buildLocation(),
                  MatchPage(
                    amplifyState: amplifyState,
                  ),
                  const MessagingPage(),
                  const ProfilePage()
                ]))));
  }

  Widget _buildLocation() {
    Future<List<UserModel>> allUsers = amplifyState.getAllUsers();
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
                  return _buildRow(context, snapshot.data![index]);
                });
          } else {
            return Container(
              child: Text('Loading'),
            );
          }
        });
  }

  Widget _buildRow(BuildContext context, UserModel thisUser) {
    return Card(
        child: ListTile(
            leading: Icon(Icons.person, color: Colors.black, size: 50),
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
                            amplifyState: amplifyState,
                          )));
            }));
  }
}
