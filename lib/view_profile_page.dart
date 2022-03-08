import 'package:flutter/material.dart';
import 'package:second_chance/amplify.dart';
import 'models/UserModel.dart';
// import 'models/Match.dart';
import 'match_page.dart';
import 'messaging_page.dart';
import 'profile_page.dart';
import 'amplify.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage(
      {Key? key, required this.viewUser, required this.amplifyState})
      : super(key: key);

  final UserModel viewUser;
  final AmplifyState amplifyState;
  @override
  _ViewProfilePage createState() => _ViewProfilePage(viewUser, amplifyState);
}

class _ViewProfilePage extends State<ViewProfilePage> {
  _ViewProfilePage(this.viewUser, this.amplifyState);
  final UserModel viewUser;
  final AmplifyState amplifyState;

  @override
  Widget build(BuildContext context) {
    amplifyState.createMatch(viewUser);
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                  title: Text(viewUser.Name.toString() + 's Profile'),
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
                  buildProfile(),
                  const MatchPage(),
                  const MessagingPage(),
                  const ProfilePage()
                ]))));
  }

  Widget buildProfile() {
    return ListView(physics: const BouncingScrollPhysics(), children: [
      const SizedBox(height: 24),
      ProfileWidget(
        onClicked: () async {},
      ),
      const SizedBox(height: 24),
      buildName(viewUser.Name.toString()),
      const SizedBox(height: 36),
      buildAbout(viewUser),
    ]);
  }

  Widget buildName(String name) => Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
        ],
      );

  Widget buildAbout(UserModel viewUser) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\u{1F464} ' + viewUser.Name.toString(),
              style: const TextStyle(fontSize: 20, height: 2.5),
            ),
            Text(
              '\u{1F46B} ' + viewUser.Gender.toString(),
              style: const TextStyle(fontSize: 20, height: 2.5),
            ),
            Text(
              '\u{1F382} ' + viewUser.Birthday.toString(),
              style: const TextStyle(fontSize: 20, height: 2.5),
            ),
            Text(
              '\u{1F4E7} ' + viewUser.Email.toString(),
              style: const TextStyle(fontSize: 20, height: 2.5),
            ),
            Text(
              '\u{1F4F1} ' + viewUser.PhoneNumber.toString(),
              style: const TextStyle(fontSize: 20, height: 2.5),
            ),
          ],
        ),
      );
}

class ProfileWidget extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    const image = NetworkImage('https://picsum.photos/250?image=9');

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
