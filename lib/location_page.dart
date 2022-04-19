import 'package:flutter/material.dart';
import 'package:second_chance/models/Location.dart';
import 'package:second_chance/view_date_users.dart';
import 'amplify.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'models/Date.dart';

class LocationPage extends StatefulWidget {
  const LocationPage(
      {Key? key,
      this.restorationId,
      required this.location,
      required this.amplifyState})
      : super(key: key);

  final Location location;
  final AmplifyState amplifyState;
  final String? restorationId;

  @override
  _LocationState createState() {
    // ignore: no_logic_in_create_state
    return _LocationState(location, amplifyState);
  }
}

class _LocationState extends State<LocationPage> with RestorationMixin {
  final Location location;
  final AmplifyState amplifyState;
  _LocationState(this.location, this.amplifyState);
  late Future<List<Date>> dates;

  // NOTE: DatePicker code from flutter example - https://api.flutter.dev/flutter/material/showDatePicker.html
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - 6),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));


        // Create new date object if none exist
        amplifyState.checkDate(_selectedDate.value, location);
        //amplifyState.updateLocation(location, json.encode(dates));
      });
    }
  }
  // NOTE: END DATEPICKER CODE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(location.BarName.toString()),
      ),
      // bottomNavigationBar: menu(),
      body: RefreshIndicator(
          child: _buildDates(),
          onRefresh: () {
            setState(() {
              dates = amplifyState.getAllDates(location);
            });
            return dates;
          }),
      // Button for adding a new date
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _restorableDatePickerRouteFuture.present();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  Widget _buildDates() {
    dates = amplifyState.getAllDates(location);
    return FutureBuilder<List<Date>>(
        future: dates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Text('None');
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
                  return _buildRow(context, snapshot.data![index]);
                });
          } else {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) {
                return const Text("Loading... Try Pulling Down to Refresh!");
              },
            );
          }
        });
  }

  Widget _buildRow(BuildContext context, Date date) {
    return Card(
        child: ListTile(
            title: Text(date.date.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            onTap: () {
              Navigator.push(
                 context,
                  MaterialPageRoute(
                      builder: (context) => ViewDateUsers(
                          location: location,
                          date: date,
                          amplifyState: amplifyState)));
            }));
  }
  // TODO: User for user iterators in DateViewer
  //Widget _buildRow(BuildContext context, UserModel thisUser) {
  //  return Card(
  //      child: ListTile(
  //          leading: buildImage(thisUser),
  //          title: Text(
  //            thisUser.Name.toString(),
  //            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //          ),
  //          subtitle: Text(thisUser.Gender.toString()),
  //          trailing:
  //              const Icon(Icons.person_add_alt_1, color: Colors.black, size: 40),
  //          onTap: () {
  //            Navigator.push(
  //                context,
  //                MaterialPageRoute(
  //                    builder: (context) => ViewProfilePage(
  //                          viewUser: thisUser,
  //                          // location: location,
  //                          amplifyState: amplifyState,
  //                        )));
  //          }));
  //}
}
