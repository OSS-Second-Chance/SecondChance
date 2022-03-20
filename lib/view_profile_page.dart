import 'package:flutter/material.dart';
import 'package:second_chance/amplify.dart';
import 'models/UserModel.dart';
import 'amplify.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage(
      {Key? key, required this.viewUser, required this.amplifyState})
      : super(key: key);

  final UserModel viewUser;
  final AmplifyState amplifyState;

  @override
  _ViewProfilePage createState() {
    // ignore: no_logic_in_create_state
    return _ViewProfilePage(viewUser, amplifyState);
  }
}

class _ViewProfilePage extends State<ViewProfilePage> {

  final UserModel viewUser;
  final isEdit = false;
  late AmplifyState amplifyState;
  final VoidCallback onClicked = () async {};

  NetworkImage image = NetworkImage('https://picsum.photos/250?image=9');

  _ViewProfilePage(this.viewUser, this.amplifyState) {
    try {
      amplifyState.getUserProfilePicture(viewUser).then((result) => setState(() {
        image = NetworkImage(result);
      }));
    }
    catch (_) {
      image = const NetworkImage('https://picsum.photos/250?image=9');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(viewUser.Name.toString() + "'s Profile"),
          ),
          // bottomNavigationBar: menu(),
          body: buildProfile(),
        );

  }

  Widget buildProfile() {
    return ListView(physics: const BouncingScrollPhysics(), children: [
      const SizedBox(height: 24),
      ProfileWidget(context),
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


  Widget ProfileWidget(BuildContext context) {
    final color = Theme
        .of(context)
        .colorScheme
        .primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
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
