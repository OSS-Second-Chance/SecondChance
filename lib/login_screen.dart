import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'amplify.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.amplifyState}) : super(key: key);

  final AmplifyState amplifyState;

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  GlobalKey<_LoginState> _myKey = GlobalKey();
  Duration get loginTime => Duration(milliseconds: 2250);
  late AmplifyState amplifyState;

  @override
  initState() {
    super.initState();
    amplifyState = widget.amplifyState;
  }

  Future<String?> _authUser(LoginData data) {
    debugPrint('Signin Email: ${data.name}, Password: ${data.password}');
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
        'Signup Email: ${data.name}, Password: ${data.password}, Name: ${data.additionalSignupData!["Name"]}, BirthDate: ${data.additionalSignupData!["BirthDate"]}');
    return amplifyState
        .signUp(
      data.name.toString(),
      data.password.toString(),
      data.additionalSignupData!["Name"].toString(),
    ).then((result) {
      debugPrint("In signup Future return");
      debugPrint("result: " + result);
      if (result == "SuccessfulSignup") {
        amplifyState.name = data.additionalSignupData!["Name"];
        amplifyState.email = data.name;
        amplifyState.gender = data.additionalSignupData!["Gender"];
        amplifyState.birthdate = data.additionalSignupData!["BirthDate"];
        amplifyState.number = data.additionalSignupData!["Number"];
        return null;
      } else {
        return result;
      }
    });
  }

  Future<String?>? _confirmSignUp(String code, LoginData data) async {
    debugPrint('in confirmSignUp error: $code data: $data');

    String error = '';
    amplifyState
        .confirmSignUp(data.name.toString(), code.toString())
        .then((result) {
      debugPrint("In confirmsignup Future return");
      debugPrint("result: " + result);
      if (result == "SuccessfulConfirmation") {
        //createUser(data);
        amplifyState
            .loginUser(data.name.toString(), data.password.toString())
            .then((loginResult) {
          if (loginResult == "SuccessfulLogin") {
            amplifyState.createUser();
            debugPrint(data.toString());

            return null;
          } else {
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
    List<UserFormField> additionalAttributes =
        List<UserFormField>.filled(4, const UserFormField(keyName: "Name"));
    additionalAttributes[1] = const UserFormField(keyName: "Number");
    additionalAttributes[2] = const UserFormField(keyName: "Gender");
    additionalAttributes[3] = const UserFormField(keyName: "BirthDate");
    return FlutterLogin(
      title: 'SecondChance',
      onLogin: _authUser,
      onSignup: _signupUser,
      onConfirmSignup: _confirmSignUp,
      passwordValidator: _passwordValidator,
      additionalSignupFields: additionalAttributes,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      onRecoverPassword: _recoverPassword,
    );
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
