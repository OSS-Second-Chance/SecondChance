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
          buildLabelTest('My Matches'),
          _buildMatches(myMatches, 'Matches'),
          const SizedBox(height: 48),
          buildLabelTest('My Admirers'),
          _buildMatches(myAdmirers, 'Admirers'),
          const SizedBox(height: 48),
          buildLabelTest('My Requests'),
          _buildMatches(myRequests, 'Requests'),
          // _buildAdmirers(),
          // _buildRequests()
        ],
      ),
    );
  }

  Widget buildLabelTest(String label) => Column(children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.blueAccent,
                decoration: TextDecoration.underline),
          ),
        ),
      ]);
  Widget buildEmpty(String output) => Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 20),
          child: Text(
            output,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black26,
            ),
          ),
        ),
      ]);

  Widget _buildMatches(Future<List<UserModel>> matchType, String type) {
    //debugPrint("SHOULD BE After This");
    //debugPrint(matchType.toString());
    return FutureBuilder<List<UserModel>>(
        future: matchType,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              if (type == 'Requests') {
                return buildEmpty("Visit a recent location\nto send out $type");
              }
              return buildEmpty("It's okay!\nYou'll get some $type soon");
            }
            debugPrint("$type:");
            return Text('User: ${snapshot.data!.first.Name}');
          } else {
            return Text('Loading');
          }
        });
  }
}
