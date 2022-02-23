import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'amplify.dart';
// import 'package:amplify_api/amplify_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(title: "SecondChance"),
      routes: {
        'dashboard': (context) => const DashboardScreen(title: "SecondChance"),
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<DashboardScreen> createState() => MyHomePageState();
}

class MyHomePageState extends State<DashboardScreen> {
  int counter = 0;
  AmplifyState amplifyState = AmplifyState();
  String userButton = "Sign Out";

  @override
  initState() {
    super.initState();
    amplifyState.configureAmplify(context, amplifyState, this);
  }

  void setUserState() {
    setState(() {
      bool test = amplifyState.getLoggedIn();
      debugPrint("in set user state, logged in: $test");
      if (amplifyState.getLoggedIn()) {
        userButton = "Sign Out";
      } else {
        userButton = "Sign In";
      }
    });
  }


  Widget _buildLocations() {
    var location_list = ["Harry's", "Brother's", "Twisted Hammer"];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: (location_list.length * 2),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }

        final index = i ~/ 2;
        return _buildRow(location_list[index]);
      },
    );
  }

  Widget _buildRow(String title) {
    return ListTile(
        title: Text(title),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPage(location: title)));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    if (amplifyState.getLoggedIn()) {
                      amplifyState.signOut();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                  key: null, amplifyState: amplifyState)));
                    }
                  },
                  child: Text(userButton)))
        ],
      ),
      body: _buildLocations(),
    );
  }
}

// Location page class, will move to another file once it's less bare-bones

class LocationPage extends StatelessWidget {
  const LocationPage({Key? key, required this.location}) : super(key: key);

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
      ),
    );
  }
}
