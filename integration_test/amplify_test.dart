import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:second_chance/amplify.dart';
import 'package:integration_test/integration_test.dart';
import 'package:second_chance/models/Date.dart';
import 'package:second_chance/models/UserModel.dart';
import 'package:second_chance/models/Location.dart';

void main() async {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  AmplifyState state = AmplifyState();
  final _random = Random();
  group('Amplify Functionality', () {

  testWidgets('Amplify Configure', (tester) async {

      await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
      final BuildContext context = tester.element(find.byType(Container));
      await state.configureAmplify(context, state);
      expect(state.isAmplifyConfigured, true);

  });

    test('Amplify Login', () async {
      expect(state.loggedIn, false);
      await state.loginUser("LADent99@gmail.com", "Apple2010!");
      expect(state.loggedIn, true);
    });

    test('Amplify Location Query', () async {
      List<Location> locations = await state.getAllLocations();
      Future.delayed(const Duration(milliseconds: 4000), () {
        expect(locations.isNotEmpty, true);

      });

    });

    test('Amplify Date Query', () async {
      //Setup
      List<Location> locations = await state.getAllLocations();
      Future.delayed(const Duration(milliseconds: 4000), () async {
        Location location = locations[_random.nextInt(locations.length)];

      //Test
      List<Date> dates = await state.getAllDates(location);
      Future.delayed(const Duration(milliseconds: 4000), () {
        expect(dates.isNotEmpty, true);
      });
      });
    });

      test('Amplify User Date Checks', () async {
        //Setup
        List<Location> locations = await state.getAllLocations();

        Future.delayed(const Duration(milliseconds: 4000), () async {
        Location location = locations[_random.nextInt(locations.length)];
        List<Date> dates = await state.getAllDates(location);
        Future.delayed(const Duration(milliseconds: 4000), () async {
        Date date = dates[_random.nextInt(dates.length)];

        //Test
        UserModel user = await state.getUserProfile() as UserModel;
        if (!(await state.checkDateUser(date, user.id))) {
          // Join list if not in
          await state.addUsertoDate(date, user.id);
        }

        //Check for empty list
        List<UserModel> users = await state.getUsersFromDate(date);
        Future.delayed(const Duration(milliseconds: 4000), () {
          expect(users.isNotEmpty, true);
        });

        //Remove User
        bool check = await state.checkDateUser(date, user.id);
        Future.delayed(const Duration(milliseconds: 4000), () {
          expect(check, true);
        });
        await state.removeUserFromDate(date, user.id);
        check = await state.checkDateUser(date, user.id);
        Future.delayed(const Duration(milliseconds: 4000), () {
          expect(check, false);
        });
        // Add User
        await state.addUsertoDate(date, user.id);
        check = await state.checkDateUser(date, user.id);
        Future.delayed(const Duration(milliseconds: 4000), () {
          expect(check, true);
        });
        });
        });
      });


    test('Amplify Signout', () async {
      expect(state.loggedIn, true);
      await state.signOut();
      expect(state.loggedIn, false);
    });
  });
}