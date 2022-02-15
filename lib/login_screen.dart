import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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
  Duration get loginTime => Duration(milliseconds: 2250);
  late AmplifyState amplifyState;

  @override
  initState() {
    super.initState();
    amplifyState = widget.amplifyState;
  }

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return "User: " + data.name;
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Email: ${data.name}, Password: ${data.password}, Name: ${data.additionalSignupData!["Name"]}' );
    return amplifyState.signUp(data.name.toString(),
        data.password.toString(),
        data.additionalSignupData!["Name"].toString())
        .then((result) {
            debugPrint("In signup Future return");
            debugPrint("result: " + result);
            if (result == "SuccessfulSignup") {
              return null;
            }
            else {
              return result;
            }
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SecondChance',
      onLogin: _authUser,
      onSignup: _signupUser,
      additionalSignupFields: List<UserFormField>.filled(1, const UserFormField(keyName: "Name")),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
