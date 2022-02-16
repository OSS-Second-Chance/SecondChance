import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'amplify.dart';
import 'main.dart';
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';
import 'models/UserModel.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'amplifyconfiguration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.amplifyState}) : super(key: key);

  final AmplifyState amplifyState;

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 2250);
  late AmplifyState amplifyState;

  @override
  initState() {
    super.initState();
    amplifyState = widget.amplifyState;
  }

  Future<String?> _authUser(LoginData data) {
    debugPrint(
        'Signin Email: ${data.name}, Password: ${data.password}');
    return amplifyState
        .loginUser(data.name.toString(), data.password.toString())
        .then((result) {
      debugPrint("In authUser Future return");
      debugPrint("result: " + result);
      if (result == "SuccessfulLogin") {
        return null;
      } else {
        return result;
      }
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint(
        'Signup Email: ${data.name}, Password: ${data.password}, Name: ${data.additionalSignupData!["Name"]}');
    return amplifyState
        .signUp(data.name.toString(), data.password.toString(),
            data.additionalSignupData!["Name"].toString())
        .then((result) {
      debugPrint("In signup Future return");
      debugPrint("result: " + result);
      if (result == "SuccessfulSignup") {
        return null;
      } else {
        return result;
      }
    });
  }

  Future<String?>? _confirmSignUp(String code, LoginData data) async {
    debugPrint(
        'in confirmSignUp error: $code data: $data');

    String error = '';
    amplifyState
        .confirmSignUp(data.name.toString(), code.toString())
        .then((result) {
      debugPrint("In confirmsignup Future return");
      debugPrint("result: " + result);
      if (result == "SuccessfulConfirmation") {

        //createUser(data);
        amplifyState.loginUser(data.name.toString(), data.password.toString())
        .then((loginResult) {
          if (loginResult == "SuccessfulLogin") {
            return null;
          }
          else {

            error += "Login Error: " + loginResult;
          }
        });
      } else {
        error += "\nSignup Error: " + result;
      }
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  String? _passwordValidator(String? password) {
    //Fillout STUFF
    return null;
    //return string error message on failed validation

  }
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SecondChance',
      onLogin: _authUser,
      onSignup: _signupUser,
      onConfirmSignup: _confirmSignUp,
      passwordValidator: _passwordValidator,
      additionalSignupFields:
          List<UserFormField>.filled(1, const UserFormField(keyName: "Name")),
      onSubmitAnimationCompleted: () {

        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      onRecoverPassword: _recoverPassword,
    );
  }

  void createUser(SignupData data) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: data.name.toString(),
        password: data.password.toString(),
      );
    } on AuthException catch (e) {
      print(e.message);
    }

    debugPrint("Creating User");
    AuthUser? curUser;
    try {
      curUser = await Amplify.Auth.getCurrentUser();
      debugPrint(curUser.username);
      debugPrint("-----");
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
    // final _testID = 'abc';
    final currentUser = UserModel(
        id: data.name, Name: data.additionalSignupData!["Name"].toString());

    try {
      await Amplify.DataStore.save(currentUser);

      print('Saved ${currentUser.toString()}');
    } catch (e) {
      print(e);
    }
  }
}
