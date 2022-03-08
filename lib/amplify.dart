import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:second_chance/main.dart';
import 'amplifyconfiguration.dart';
import 'login_screen.dart';
import 'models/ModelProvider.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';

class AmplifyState {
  bool isAmplifyConfigured = false;
  bool loggedIn = false;
  late String? name;
  late String? email;
  late String? gender;
  late String? birthdate;
  late String? number;
  late MyHomePageState homePageState;
  // final AmplifyDataStore _amplifyDataStore = AmplifyDataStore(
  //   modelProvider: ModelProvider.instance,
  // );

  void configureAmplify(BuildContext context, AmplifyState amplifyState,
      MyHomePageState myHomePageState) async {
    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    homePageState = myHomePageState;
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyDataStore datastorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    AmplifyAPI _amplifyAPI = AmplifyAPI(modelProvider: ModelProvider.instance);

    await Amplify.addPlugins(
        [datastorePlugin, authPlugin, _amplifyAPI, AmplifyStorageS3()]);
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginScreen(key: null, amplifyState: amplifyState)));
        return;
      }
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
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
          options: CognitoSignUpOptions(userAttributes: userInfo));

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

  Future<List<UserModel>> getAllUsers() async {
    try {
      List<UserModel> allUsers =
          await Amplify.DataStore.query(UserModel.classType);

      return (allUsers);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void createUser() async {
    // debugPrint("Creating User");
    AuthUser? curUser;

    try {
      curUser = await Amplify.Auth.getCurrentUser();
      debugPrint("ASGDHRJYJHGREFWGRH");
      debugPrint(curUser.username);
      debugPrint("ASGDHRJYJHGREFWGRH");
    } on AuthException catch (e) {
      debugPrint(e.message);
    }

    final currentUser = UserModel(
        id: curUser?.userId,
        AuthUsername: curUser?.userId,
        Name: name,
        Gender: gender,
        Email: email,
        Birthday: birthdate,
        PhoneNumber: number);

    try {
      await Amplify.DataStore.save(currentUser);

      print('Saved ${currentUser.toString()}');
    } catch (e) {
      print(e);
    }

    //Test EditProfile Functionality
    // readAll();
    // final userProfile = getUserProfile();
    // updateProfileAttribute('Gender', 'Male');
    // debugPrint("Get User profile XXXXXX");
    // final userProfile2 = getUserProfile();
    // clearLocalDataStore();
    // debugPrint("Get User profile");
  }

  //Test to read entire User List, ignore in production
  void readAllUsers() async {
    try {
      final allUsers = await Amplify.DataStore.query(UserModel.classType);

      debugPrint("Test readall()");
      debugPrint(allUsers.toString());
      debugPrint(allUsers.toString());
      debugPrint("----");
    } catch (e) {
      print(e);
    }
  }

  static void readAllLocations() async {
    try {
      List<Location> locations =
          await Amplify.DataStore.query(Location.classType);

      debugPrint("Test readall() Locations");
      debugPrint(locations.toString());
      debugPrint("----");
    } catch (e) {
      print(e);
    }
  }

  Future<List<Location>> getAllLocations() async {
    try {
      List<Location> locations =
          await Amplify.DataStore.query(Location.classType);

      return (locations);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final activeUsers = await Amplify.DataStore.query(UserModel.classType,
          where: UserModel.AUTHUSERNAME.eq(activeID));

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

  void createMatch(UserModel viewUser) async {
    getUserProfile().then((curUser) {
      debugPrint('HERE XXXXX');
      debugPrint(curUser.Name.toString());
      debugPrint(viewUser.Name.toString());

      final newMatch = Match(
        User1Name: curUser.Name,
        User1ID: curUser.AuthUsername,
        User1Check: true,
        User2Name: viewUser.Name,
        User2ID: viewUser.AuthUsername,
        User2Check: true,
      );

      try {
        Amplify.DataStore.save(newMatch);
        print(
            'New Match between ${newMatch.User1Name} and ${newMatch.User2Name}');
      } catch (e) {
        print(e);
      }
    });
  }

  void clearLocalDataStore() async {
    try {
      debugPrint("WARNING: Clearing DB");
      await Amplify.DataStore.clear();
    } catch (e) {
      print(e);
    }
  }
}
