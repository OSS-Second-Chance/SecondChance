import 'package:flutter/material.dart';
import 'package:second_chance/models/Location.dart';
import 'models/Date.dart';
import 'models/UserModel.dart';
import 'dart:async';
import 'view_profile_page.dart';
import 'amplify.dart';
import 'dart:convert';

class ViewDateUsers extends StatefulWidget {
  const ViewDateUsers(
      {Key? key, required this.location, required this.date, required this.amplifyState})
      : super(key: key);

  final AmplifyState amplifyState;
  final Date date;
  final Location location;

  @override
  _ViewDateUsersState createState() {
    // ignore: no_logic_in_create_state
    return _ViewDateUsersState(location, date, amplifyState);
  }
}

class _ViewDateUsersState extends State<ViewDateUsers> {
  Date date;
  final AmplifyState amplifyState;
  final Location location;
  _ViewDateUsersState(this.location, this.date, this.amplifyState);
  late String user;
  String userText = "Temp";
  bool userJoin = true;
  late Future<List<UserModel>> users;
  @override
  initState() {
    super.initState();

    amplifyState.getCurrentAuthUser().then((result) {
      user = result.userId;
      amplifyState.checkDateUser(date, user).then((result) {
        if (!result) {
          setState(() {
            userText = "Join this List";
            userJoin = true;
          });

        } else {
          setState(() {
            userText = "Leave this List";
            userJoin = false;
          });
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("${date.date} At ${location.BarName}"),
        ),
        // bottomNavigationBar: menu(),
        body: RefreshIndicator(
          child: _buildUsers(),
          onRefresh: ()  {

            return amplifyState.getUsersFromDate(date).then((_) {
              amplifyState.getCurrentAuthUser().then((result) {
                user = result.userId;
                amplifyState.checkDateUser(date, user).then((result) {
                  if (!result) {
                    setState(() {
                      userText = "Join this List";
                      userJoin = true;
                    });

                  } else {
                    setState(() {
                      userText = "Leave this List";
                      userJoin = false;
                    });
                  }

                });
              });


          }
        );}),
        floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            debugPrint("Attempting add of User: $user");


            amplifyState.getCurrentAuthUser().then((result) {
              user = result.userId;
              amplifyState.checkDateUser(date, user).then((result){
                if (result) {
                  amplifyState.removeUserFromDate(date, user);
                  setState(() {
                    userText = "Join this List";
                    userJoin = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'You have been removed from $date under ${location.BarName}'),
                  ));
                } else {
                  amplifyState.addUsertoDate(date, user);
                  setState(() {
                    userText = "Leave this List";
                    userJoin = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'You have been added to $date under ${location.BarName}'),
                  ));
                }

              });
            });

          });
        },
        label: Text(userText),
        icon: userIcon(),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget userIcon() {
    if (userJoin) {
      return const Icon(Icons.add, color: Colors.white);
    } else {
      return const Icon(Icons.remove, color: Colors.white);
    }
  }

  // TODO: Change - Old function for listing all users
  Widget _buildUsers() {
    users = amplifyState.getUsersFromDate(date);
    return FutureBuilder<List<UserModel>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Text('None');
            }
            debugPrint(snapshot.data.toString());
            return ListView.builder(
              // padding: const EdgeInsets.all(16),
                itemCount: (snapshot.data!.length * 2),
                itemBuilder: (context, i) {
                  if (i.isOdd) {
                    return const Divider();
                  }

                  final index = i ~/ 2;
                  return _buildRow(context, snapshot.data![index]);
                });
          } else {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) {
                return const Text("Loading... Try Pulling Down to Refresh!");
              },
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
                  child: const InkWell(),
                ),
              ),
            );
          }
          return const Icon(Icons.person, color: Colors.black, size: 50);
        });
  }

  // TODO: User for user iterators in DateViewer
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
                const Icon(Icons.person_add_alt_1, color: Colors.black, size: 40),
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
