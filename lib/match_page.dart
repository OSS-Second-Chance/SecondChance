import 'package:flutter/material.dart';
import 'package:second_chance/models/Location.dart';
import 'models/UserModel.dart';
import 'models/Match.dart';
import 'dart:async';
import 'match_page.dart';
import 'view_profile_page.dart';
import 'messaging_page.dart';
import 'profile_page.dart';
import 'amplify.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({Key? key, required this.amplifyState}) : super(key: key);

  final AmplifyState amplifyState;
  // final curUser = amplifyState.getUserProfile();

  @override
  Widget build(BuildContext context) {
    return ListView(physics: const BouncingScrollPhysics(), children: [
      const Text(
        "Matches",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      // const SizedBox(height: 4),
      _buildMatches(amplifyState.getMyMatches()),
      // const SizedBox(height: 24),
      const Text(
        "Admirers",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      // const SizedBox(height: 4),
      _buildAdmirers(),
      // const SizedBox(height: 24),
      const Text(
        "Requests",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      // const SizedBox(height: 4),
      _buildRequests(),
      // const SizedBox(height: 24),
    ]);
  }

  Widget _buildMatches(Future<List<Match>> matchType) {
    return FutureBuilder<List<Match>>(
        future: matchType,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            print(snapshot.data.toString());
            return ListView.builder(
                padding: const EdgeInsets.all(8),
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

  Widget _buildAdmirers() {
    Future<List<Match>> allAdmirers = amplifyState.getMyAdmirers();
    return FutureBuilder<List<Match>>(
        future: allAdmirers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            print(snapshot.data.toString());
            return ListView.builder(
                padding: const EdgeInsets.all(8),
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

  Widget _buildRequests() {
    Future<List<Match>> allRequests = amplifyState.getMyRequests();
    return FutureBuilder<List<Match>>(
        future: allRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            print(snapshot.data.toString());
            return ListView.builder(
                padding: const EdgeInsets.all(8),
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

  Widget _buildRow(BuildContext context, Match thisMatch) {
    return Card(
        child: ListTile(
            leading: Icon(Icons.person, color: Colors.black, size: 50),
            title: Text(
              thisMatch.User2Name.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(thisMatch.User1Name.toString()),
            trailing:
                Icon(Icons.person_add_alt_1, color: Colors.black, size: 40),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagingPage(
                          // viewUser: thisMatch,
                          // amplifyState: amplifyState,
                          )));
            }));
  }
}
