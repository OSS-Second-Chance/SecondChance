import 'package:flutter/material.dart';
import 'package:second_chance/amplify.dart';
import 'package:second_chance/my_profile_page.dart';
import 'models/UserModel.dart';
import 'models/Location.dart';
import 'amplify.dart';

class EditMyProfilePage extends StatefulWidget {
  const EditMyProfilePage(
      {Key? key,
        required this.viewUser,
        // this.location,
        required this.amplifyState})
      : super(key: key);

  final UserModel viewUser;
  // final Location location;
  final AmplifyState amplifyState;

  @override
  EditMyProfilePageState createState() {
    // ignore: no_logic_in_create_state
    return EditMyProfilePageState(viewUser, amplifyState);
  }
}

class EditMyProfilePageState extends State<EditMyProfilePage> {
  late UserModel viewUser;
  late AmplifyState amplifyState;
  // late Location location;
  EditMyProfilePageState(this.viewUser, this.amplifyState);
  NetworkImage image = NetworkImage('https://picsum.photos/250?image=9');
  final VoidCallback onClicked = () async {};
  final isEdit = false;
  List<String> list = ["A", "B", "C", "D"];
  String displayText = 'Placeholder Text';
  void action;
  String status = 'ShouldBeChanged';
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String gender;
  late String birthday;
  late String work;
  late String school;
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Edit Profile"),
      ),
      body: buildProfile(),
    );
  }

  Widget buildProfile() {
    return ListView(physics: const BouncingScrollPhysics(), children: [
      const SizedBox(height: 24),
      ProfileWidget(context),
      //editName(),
      const SizedBox(height: 36),
      editAbout(),
    ]);
  }

  Widget editName() => Column(
    children: const [
       TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
              labelText: 'name'
        )
      ),
      SizedBox(height: 4),
    ],
  );

  Widget editAbout() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Form (
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextFormField(
              initialValue: viewUser.Name.toString(),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                name = value;
                return null;
              },
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: viewUser.Gender.toString(),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              gender = value;
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: viewUser.Birthday.toString(),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Birthday'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              birthday = value;
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: (viewUser.School != null) ? viewUser.School.toString(): "",
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'School'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              school = value;
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: (viewUser.Work != null) ? viewUser.Work.toString() : "",
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Work'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              work = value;
              return null;
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                amplifyState.updateProfileAttribute(name, birthday, gender, school, work);
                Navigator.pop(context);
              }
            },
            child: const Text('Update Profile'),
          ),
        ],
    ),
    ),
  );

  Widget ProfileWidget(BuildContext context) {
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
                amplifyState.uploadImage(this);
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