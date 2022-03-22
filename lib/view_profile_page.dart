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
  final AmplifyState amplifyState;
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
      amplifyState.getUserProfilePicture(viewUser).then((result) => setState(() {
        image = NetworkImage(result);
      }));
    }
    catch (_) {
      image = const NetworkImage('https://picsum.photos/250?image=9');
    }

    amplifyState.getMatchStatus(viewUser).then((tempStatus) {
      status = tempStatus;
      debugPrint(status);

      debugPrint("XXXXXXXYYYYY");
      debugPrint(status);
      debugPrint("Above");
      if (status == 'NoMatch') {
        setState(() {
          displayText = 'Request Match';
        });
      } else if (status == 'Match') {
        setState(() {
          displayText = 'Unmatch';
        });
      } else if (status == 'Outgoing') {
        setState(() {
          displayText = 'Remove Request';
        });
      } else if (status == 'Incoming') {
        setState(() {
          displayText = 'Accept Request';
        });
      }

      debugPrint("Here");
      debugPrint(status);
      debugPrint('Did we get status?');
      debugPrint(displayText);
    });

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
      buildMatchButton(viewUser),
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

  Widget buildMatchContainer(UserModel viewUser, displayText, action) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                action;
              },
              child: Text(displayText),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.red, // background
            //     onPrimary: Colors.white, // foreground
            //   ),
            //   onPressed: () {
            //     amplifyState
            //         .getMatch(viewUser)
            //         .then((curMatch) => amplifyState.unMatch(curMatch));
            //   },
            //   child: Text('Unmatch'),
            // ),
          ],
        ),
      );

  Widget buildMatchButton(UserModel viewUser) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <ElevatedButton>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
            if (status == 'NoMatch') {
              action = amplifyState.createMatch(viewUser);
            } else if (status == 'Match') {
              amplifyState
                  .getMatch(viewUser)
                  .then((curMatch) => action = amplifyState.unMatch(curMatch));
            } else if (status == 'Outgoing') {
              amplifyState
                  .getMatch(viewUser)
                  .then((curMatch) => action = amplifyState.unMatch(curMatch));
            } else if (status == 'Incoming') {
              amplifyState.getMatch(viewUser).then(
                  (curMatch) => action = amplifyState.approveRequest(curMatch));
            }
            Future.delayed(const Duration(milliseconds: 500), () {
              amplifyState.getMatchStatus(viewUser).then((tempStatus) {
                status = tempStatus;

                if (status == 'NoMatch') {
                  setState(() {
                    displayText = 'Request Match';
                  });
                } else if (status == 'Match') {
                  setState(() {
                    displayText = 'Unmatch';
                  });
                } else if (status == 'Outgoing') {
                  setState(() {
                    displayText = 'Remove Request';
                  });
                } else if (status == 'Incoming') {
                  setState(() {
                    displayText = 'Accept Request';
                  });
                }

                debugPrint("Here");
                debugPrint(status);
                debugPrint('Did we get status?');
                debugPrint(displayText);
              });
            });
          },
          child: Text(displayText),
        ),
      ],
    );
    // Future.delayed(const Duration(milliseconds: 5000), () {return Column();});
  }
}


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
