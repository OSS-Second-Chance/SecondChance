import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'amplify.dart';
import 'my_profile_page.dart';
import 'match_page.dart';
import 'messaging_page.dart';
import 'location_page.dart';
import 'models/ModelProvider.dart';
import 'models/Location.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Second Chance',
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

class MyHomePageState extends State<DashboardScreen> with SingleTickerProviderStateMixin{
  int counter = 0;
  AmplifyState amplifyState = AmplifyState();
  String userButton = "Sign Out";
  String AppStage = "Profile";
  late Widget AppState;
  // var locationList = <Location>[].obs;

  late TabController _controller;
  int _selectedIndex = 0;
  List<Widget> list = [
    const Tab(icon: Icon(Icons.location_on_sharp)),
    const Tab(icon: Icon(Icons.social_distance_outlined)),
    const Tab(icon: Icon(Icons.messenger_rounded)),
    const Tab(icon: Icon(Icons.settings_accessibility))];

  @override
  initState() {
    super.initState();
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });;
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


    Widget _buildRow(Location curLocation) {
      return Card(
          child: ListTile(
              leading: Icon(Icons.wine_bar, color: Colors.black, size: 50),
              title: Text(
                curLocation.BarName.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(curLocation.Region.toString()),
              trailing: Icon(Icons.add_location_alt_sharp,
                  color: Colors.orange, size: 40),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LocationPage(location: curLocation, amplifyState: amplifyState,)));
              }));
    }

  Widget _buildLocations() {
    Future<List<Location>> locations = amplifyState.getAllLocations();
    return FutureBuilder<List<Location>>(
        future: locations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            print(snapshot.data.toString());
            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: (snapshot.data!.length * 2),
                itemBuilder: (context, i) {
                  if (i.isOdd) {
                    return const Divider();
                  }

                  final index = i ~/ 2;
                  return _buildRow(snapshot.data![index]);
                });
          } else {
            return Container(
              child: Text('Loading'),
            );
          }
        });
  }

  Widget _buildRow(Location curLocation) {
    return Card(
        child: ListTile(
            leading: Icon(Icons.wine_bar, color: Colors.black, size: 50),
            title: Text(
              curLocation.BarName.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(curLocation.Region.toString()),
            trailing: Icon(Icons.add_location_alt_sharp,
                color: Colors.orange, size: 40),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationPage(
                            location: curLocation,
                            amplifyState: amplifyState,
                          )));
            }));
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
        home: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    onTap: (index) {

                    },
                    controller: _controller,
                    tabs: list,
                  ),

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
                                            key: null,
                                            amplifyState: amplifyState)));
                              }
                            },
                            child: Text(userButton)))
                  ],
                ),
                // bottomNavigationBar: menu(),

                body: TabBarView(
                  controller: _controller,
                  children: [
                    _buildLocations(),
                    const MatchPage(amplifyState: amplifyState),
                    const MessagingPage(),
                    ProfilePage(amplifyState: amplifyState)
                  ]
                )));

  }
}
