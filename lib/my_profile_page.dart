import 'package:flutter/material.dart';
import 'package:second_chance/amplify.dart';
import 'edit_my_profile_page.dart';
import 'models/UserModel.dart';
import 'models/Location.dart';
import 'amplify.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage(
      {Key? key,
        required this.viewUser,
        // this.location,
        required this.amplifyState})
      : super(key: key);

  final UserModel viewUser;
  // final Location location;
  final AmplifyState amplifyState;

  @override
  MyProfilePageState createState() {
    // ignore: no_logic_in_create_state
    return MyProfilePageState(viewUser, amplifyState);
  }
}

class MyProfilePageState extends State<MyProfilePage> {
  late UserModel viewUser;
  late AmplifyState amplifyState;
  // late Location location;
  MyProfilePageState(this.viewUser, this.amplifyState);
  NetworkImage image = NetworkImage('https://picsum.photos/250?image=9');
  final VoidCallback onClicked = () async {};
  final isEdit = false;
  List<String> list = ["A", "B", "C", "D"];
  String displayText = 'Placeholder Text';
  void action;
  String status = 'ShouldBeChanged';
  // Here
  @override
  initState() {
    super.initState();

    try {
      amplifyState
          .getUserProfilePicture(viewUser)
          .then((result) => setState(() {
        image = NetworkImage(result);
      }));
    } catch (_) {
      image = const NetworkImage('https://picsum.photos/250?image=9');
    }
  }

  newProfileImage() {
    setState(() {
      image = amplifyState.profilePicture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildProfile(),
    );
  }

  Widget buildProfile() {
    return ListView(physics: const BouncingScrollPhysics(), children: [
      const SizedBox(height: 24),
      ProfileWidget(viewUser, context),
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
        const Text(
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

  Widget ProfileWidget(UserModel viewUser, BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

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
          child: InkWell(
              onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditMyProfilePage(
                viewUser: viewUser,
                // location: location,
                amplifyState: amplifyState,
              )));
          }
          ),
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