import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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

class MyHomePageState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int counter = 0;
  AmplifyState amplifyState = AmplifyState();
  String userButton = "Sign Out";

  String AppStage = "Profile";
  late Widget AppState;
  late Future<List<Location>> locations;
  bool loading = true;
  // String dropDownValue;
  // TextEditingController textController;

  // var locationList = <Location>[].obs;

  late TabController _controller;
  List<Widget> list = [
    const Tab(icon: Icon(Icons.location_on_sharp)),
    const Tab(icon: Icon(Icons.social_distance_outlined)),
    const Tab(icon: Icon(Icons.messenger_rounded)),
    const Tab(icon: Icon(Icons.settings_accessibility))
  ];

  @override
  initState() {
    super.initState();
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {});
      debugPrint("Selected Index: " + _controller.index.toString());
    });
    amplifyState.configureAmplify(context, amplifyState).then((_) {
      finishedLoading();
    });
    // amplifyState.clearLocalDataStore();
  }

  finishedLoading() {
    Future.wait([tempLocations()]).then((_) {
      setState(() {
        loading = false;

      });
    });
  }

  Future<void> tempLocations() async {
    locations = amplifyState.getAllLocations();
  }

  Widget _buildRowNew(Location curLocation) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFC8CED5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.wine_bar,
                          color: Colors.black,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              curLocation.BarName,
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF15212B),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                                child: Text(
                                  curLocation.Region,
                                  style: const TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF82878C),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationPage(
                            location: curLocation,
                            amplifyState: amplifyState,
                          )));
            }),
      ],
    );
  }

  Widget _buildLocations() {
    return FutureBuilder<List<Location>>(
        future: locations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, i) {
                  return const Center(child: Text("Loading... Try Pulling Down to Refresh!"));
                },
              );
            }
            debugPrint(snapshot.data.toString());
            return ListView.builder(
              // padding: const EdgeInsets.all(16),
                itemCount: (snapshot.data!.length * 2),
                itemBuilder: (context, i) {
                  if (i.isOdd) {
                    return const Divider();
                  }

                  final index = i ~/ 2;
                  return _buildRowNew(snapshot.data![index]);
                });
          } else {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) {
                return const Center(child: Text("Loading... Try Pulling Down to Refresh!"));
              },
            );
          }
        });
  }

  Widget _buildMyProfilePage() {
    try {
      Future<dynamic> currentUser = amplifyState.getUserProfile();

      return FutureBuilder<dynamic>(
          future: currentUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return MyProfilePage(
                  viewUser: snapshot.requireData, amplifyState: amplifyState);
            } else {
              return const Text('Loading');
            }
          }
      );
    } on SignedOutException {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (loading == true) {
      return const Center(child: CircularProgressIndicator());
    }
    else {

      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                  bottom: TabBar(
                    onTap: (index) {},
                    controller: _controller,
                    tabs: list,
                  ),

                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text(widget.title),
                  actions: [
                    TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          amplifyState.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                      key: null, amplifyState: amplifyState)));
                        },
                        child: const Text("Sign Out"))
                  ]),
              // bottomNavigationBar: menu(),

              body: TabBarView(controller: _controller, children: [
                RefreshIndicator(child: _buildLocations(),
                    onRefresh: () {
                      setState(() {
                        locations = amplifyState.getAllLocations();
                      });
                      return locations;
                    }),
                MatchPage(amplifyState: amplifyState),
                const MessagingPage(),
                _buildMyProfilePage()
              ])));
    }
  }
}
