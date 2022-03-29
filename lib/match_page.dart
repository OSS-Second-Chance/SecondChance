import 'package:flutter/material.dart';
import 'package:second_chance/amplify.dart';
import 'package:second_chance/models/UserModel.dart';
import 'location_page.dart';
import 'models/Match.dart';
import 'dart:async';

import 'messaging_page.dart';

import 'amplify.dart';
import 'view_profile_page.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key, required this.amplifyState}) : super(key: key);

  final AmplifyState amplifyState;
  // final curUser = amplifyState.getUserProfile();
  @override
  _MatchPage createState() {
    // ignore: no_logic_in_create_state
    return _MatchPage(amplifyState);
  }
}

class _MatchPage extends State<MatchPage> {
  late AmplifyState amplifyState;
  _MatchPage(this.amplifyState);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Future<List<Match>> myMatches = amplifyState.getMyMatches();
    Future<List<UserModel>> myMatches = amplifyState.getMyMatchesUsers();
    Future<List<UserModel>> myAdmirers = amplifyState.getMyAdmirersUsers();
    Future<List<UserModel>> myRequests = amplifyState.getMyRequestsUsers();

    Color _color = Theme.of(context).primaryColor;
    return Scaffold(
      // bottomNavigationBar: menu(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          buildMatchType(myMatches, _color, 'My Matches'),
          buildMatchType(myAdmirers, _color, 'My Admirers'),
          buildMatchType(myRequests, _color, 'My Requests'),
        ],
      ),
    );
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

  Widget buildMatchType(
          Future<List<UserModel>> matchType, Color _color, String label) =>
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Text(
                label,
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    color: _color),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 9, 0, 0),
              child: FutureBuilder<List<UserModel>>(
                future: matchType,
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }
                  List<UserModel> selectedUser = snapshot.data!;
                  // Return an empty Container when the document does not exist.
                  if (snapshot.data!.isEmpty) {
                    return Container();
                  }
                  final rowUsersRecord =
                      selectedUser.isNotEmpty ? selectedUser.first : null;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: FutureBuilder<List<UserModel>>(
                            future: matchType,
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                );
                              }
                              List<UserModel> matchUser = snapshot.data!;
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                children:
                                    List.generate(matchUser.length, (rowIndex) {
                                  final viewUser = matchUser[rowIndex];


                                  return Container(
                                    width: 100,
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: buildImage(viewUser),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0, 1.31),
                                          child: Text(
                                            viewUser.Name.toString()
                                            // +'\n' +viewUser.Gender.toString()
                                            ,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Lato',
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  // Widget buildLabelTest(String label) => Column(children: <Widget>[
  //       Container(
  //         margin: EdgeInsets.all(10),
  //         padding: EdgeInsets.only(left: 20),
  //         child: Text(
  //           label,
  //           style: const TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 24,
  //               color: Colors.blueAccent,
  //               decoration: TextDecoration.underline),
  //         ),
  //       ),
  //     ]);
  // Widget buildEmpty(String output) => Column(children: <Widget>[
  //       Container(
  //         margin: EdgeInsets.only(left: 10, right: 10),
  //         padding: EdgeInsets.only(left: 20),
  //         child: Text(
  //           output,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //             color: Colors.black26,
  //           ),
  //         ),
  //       ),
  //     ]);

  // Widget _buildMatches(Future<List<UserModel>> matchType, String type) {
  //   //debugPrint("SHOULD BE After This");
  //   //debugPrint(matchType.toString());
  //   return FutureBuilder<List<UserModel>>(
  //       future: matchType,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return CircularProgressIndicator();
  //         } else if (snapshot.hasData) {
  //           if (snapshot.data!.isEmpty) {
  //             if (type == 'Requests') {
  //               return buildEmpty("Visit a recent location\nto send out $type");
  //             }
  //             return buildEmpty("It's okay!\nYou'll get some $type soon");
  //           }
  //           debugPrint("$type:");
  //           return Text('User: ${snapshot.data!.first.Name}');
  //         } else {
  //           return Text('Loading');
  //         }
  //       });
  // }
}
