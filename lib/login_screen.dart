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
        'Signup Email: ${data.name}, Password: ${data.password}, Name: ${data.additionalSignupData!["Name"]}');
    return amplifyState
        .signUp(data.name.toString(), data.password.toString(),
            data.additionalSignupData!["Name"].toString(),
            )
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
            createUser();
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
    List<UserFormField> additionalAttributes = List<UserFormField>.filled(4, const UserFormField(keyName: "Name")) ;
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

  void createUser() async {
    debugPrint("Creating User");
    AuthUser? curUser;
    String _name = '';
    String _email = '';
    String _gender = '';
    String _birthday = '';

    try {
      curUser = await Amplify.Auth.getCurrentUser();
      debugPrint(curUser.username);
      debugPrint(curUser.userId);

      // debugPrint(curUser.name)
      debugPrint("-----");
    } on AuthException catch (e) {
      debugPrint(e.message);
    }

    try {
      var res = await Amplify.Auth.fetchUserAttributes();
      res.forEach((element) {
        print('key: ${element.userAttributeKey}; value: ${element.value}');
        if (element.userAttributeKey.toString() == 'name') {
          _name = element.value;
        }
        if (element.userAttributeKey.toString() == 'email') {
          _email = element.value;
        }
        if (element.userAttributeKey.toString() == 'birthday') {
          _birthday = element.value;
        }
        if (element.userAttributeKey.toString() == 'gender') {
          _gender = element.value;
        }
      });
    } on AuthException catch (e) {
      print(e.message);
    }
    // var res = await Amplify.Auth.fetchUserAttributes();
    final _testID = 'abc';
    final currentUser =
        UserModel(id: curUser?.userId, Name: _name, Gender: _gender);

    try {
      await Amplify.DataStore.save(currentUser);

      print('Saved ${currentUser.toString()}');
    } catch (e) {
      print(e);
    }

    //Test EditProfile Functionality
    readAll();
    final userProfile = getUserProfile();
    updateProfileAttribute('Name', 'NewName Test');
    final userProfile2 = getUserProfile();
  }

  //Test to read entire User List, ignore in production
  void readAll() async {
    try {
      final allUsers = await Amplify.DataStore.query(UserModel.classType);

      debugPrint("Test readall()");
      debugPrint(allUsers.toString());
      debugPrint("----");
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final activeUsers = await Amplify.DataStore.query(UserModel.classType,
          where: UserModel.ID.eq(activeID));

      if (activeUsers.isEmpty) {
        debugPrint("No objects with ID: $activeID");
        // return null;
      }

      final activeUser = activeUsers.first;
      debugPrint("Test getUserProfile()");
      debugPrint(activeUser.toString());
      debugPrint("----");

      return activeUser;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void updateProfileAttribute(String attr, String newValue) async {
    try {
      final userToUpdate = await getUserProfile();
      UserModel updatedUser = userToUpdate;
      if (attr == 'Name') {
        updatedUser = userToUpdate.copyWith(Name: newValue);
      } else if (attr == 'Birthday') {
        updatedUser = userToUpdate.copyWith(Birthday: newValue);
      } else if (attr == 'Gender') {
        updatedUser = userToUpdate.copyWith(Gender: newValue);
      }
      // if(attr == 'Age')
      // {
      //    userToUpdate.copyWith(Age: newValue);
      // }
      // if(attr == 'Email')
      // {
      //    userToUpdate.copyWith(Email: newValue);
      // }

      await Amplify.DataStore.save(updatedUser);

      print('Updated user profile to ${updatedUser.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void deleteProfile() async {
    try {
      final userToBeDeleted = await getUserProfile();

      await Amplify.DataStore.delete(userToBeDeleted);

      print('Deleted user with Name: ${userToBeDeleted.Name}');
      print('Deleted user with ID: ${userToBeDeleted.id}');
    } catch (e) {
      print(e);
    }
  }
}
