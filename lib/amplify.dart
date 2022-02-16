import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:second_chance/main.dart';
import 'amplifyconfiguration.dart';
import 'login_screen.dart';
import 'models/ModelProvider.dart';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

class AmplifyState {
  bool isAmplifyConfigured = false;
  bool loggedIn = false;
  late MyHomePageState homePageState;
  final AmplifyDataStore _amplifyDataStore =  AmplifyDataStore(modelProvider: ModelProvider.instance,);


  void configureAmplify(BuildContext context, AmplifyState amplifyState, MyHomePageState myHomePageState) async {

    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    homePageState = myHomePageState;
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyDataStore datastorePlugin =
            AmplifyDataStore(modelProvider: ModelProvider.instance);
    
    await Amplify.addPlugins([
      datastorePlugin, 
      authPlugin,
      // AmplifyAPI(),
      AmplifyStorageS3()
      ]);
    debugPrint("after adding authPlugin");
    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      debugPrint("before configure");
      await Amplify.configure(amplifyconfig);
      isAmplifyConfigured = true;
      debugPrint("Amplify Configuration Finished");
      try {
        if (isAmplifyConfigured) {
          debugPrint("in verifyLogin: Amplify is configured");
          final awsUser = await Amplify.Auth.getCurrentUser();
          loggedIn = true;
          homePageState.setUserState();
          return;
        }
      } on SignedOutException {
        loggedIn = false;
        homePageState.setUserState();
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(key: null, amplifyState: amplifyState)));
        return;
      }
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  Future<String> signUp(String email, String password, String name) async {
    try {
      Map<CognitoUserAttributeKey, String> userInfo = {
        CognitoUserAttributeKey.name: name,
      };

      SignUpResult result = await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: CognitoSignUpOptions(
              userAttributes: userInfo
          )
      );

      return "SuccessfulSignup";
    } on AuthException catch (e) {
      debugPrint("In AuthException for signUp");
      debugPrint(e.message);
      return e.message;
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {

      SignInResult result = await Amplify.Auth.signIn(
          username: email,
          password: password,
      );
      loggedIn = true;
      homePageState.setUserState();
      return "SuccessfulLogin";
    } on AuthException catch (e) {
      debugPrint("In AuthException for loginUser");
      debugPrint(e.message);
      loggedIn = false;
      homePageState.setUserState();
      return e.message;
    }
  }

  Future<String> confirmSignUp(String email, String confirmation) async {
    try {

      SignUpResult result = await Amplify.Auth.confirmSignUp(
          username: email,
          confirmationCode: confirmation,
      );

      return "SuccessfulConfirmation";
    } on AuthException catch (e) {
      debugPrint("In AuthException for confirmSignUp");
      debugPrint(e.message);
      return e.message;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      loggedIn = false;
      homePageState.setUserState();
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }

  bool getLoggedIn() {
    return loggedIn;
  }
}
