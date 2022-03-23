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

    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Your Second Chances"),
      ),
      // bottomNavigationBar: menu(),
      body: Column(
        children: [
          buildLabel('My Matches'),
          _buildMatches(myMatches),
          buildLabel('My Admirers'),
          _buildMatches(myAdmirers),
          buildLabel('My Requests'),
          _buildMatches(myRequests),
          // _buildAdmirers(),
          // _buildRequests()
        ],
      ),
    );
  }

  Widget buildLabel(String label) => Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
        ],
      );

  Widget _buildMatches(Future<List<UserModel>> matchType) {
    //debugPrint("SHOULD BE After This");
    //debugPrint(matchType.toString());
    return FutureBuilder<List<UserModel>>(
        future: matchType,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Text('No Users');
            }
            debugPrint("Check 3");
            return Text('User: ${snapshot.data!.first.Name}');
          } else {
            return Text('Loading');
          }
        });
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
