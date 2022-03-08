import 'package:flutter/material.dart';

import 'amplify.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.amplifyState}) : super(key: key);
  final AmplifyState amplifyState;
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final VoidCallback onClicked = () async {};
  final isEdit = false;
  late var image;
  late AmplifyState amplifyState;

  @override
  initState() {
    super.initState();
    amplifyState = widget.amplifyState;
    try {
        image = amplifyState.profilePicture;
    } catch (_){
      image = NetworkImage('https://picsum.photos/250?image=9');
    }
  }

  newProfileImage() {
    setState(() {
      try {
        amplifyState.getDownloadUrl().then((result) {
          image = NetworkImage(result);
        });
      } catch (_){
        image = NetworkImage('https://picsum.photos/250?image=9');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // Define user here
    //Future<UserModel> currentUser = getUserProfile();

    // ** Fix build functions to accept user data **

    return ListView(physics: const BouncingScrollPhysics(), children: [
      const SizedBox(height: 24),
      ProfileWidget(context),
      const SizedBox(height: 24),
      buildName("test_name", "test_email"),
      const SizedBox(height: 36),
      buildAbout("test_bio"),
    ]);
  }

  Widget buildName(String name, String email) => Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(String about) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );


  Widget ProfileWidget(BuildContext context) {
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
        all: 4,
        child: IconButton(
            icon: Icon(
              isEdit ? Icons.add_a_photo : Icons.edit,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              amplifyState.uploadImage();
              newProfileImage();
            })
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
