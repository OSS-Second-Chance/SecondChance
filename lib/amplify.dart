import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:second_chance/main.dart';
import 'package:second_chance/my_profile_page.dart';
import 'amplifyconfiguration.dart';
import 'login_screen.dart';
import 'models/ModelProvider.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AmplifyState {
  bool isAmplifyConfigured = false;
  bool loggedIn = false;
  final picker = ImagePicker();
  late var profilePicture;
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
          getDownloadUrl().then((result) {
            profilePicture = NetworkImage(result);
          });
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

      getDownloadUrl().then((result) {
        profilePicture = NetworkImage(result);
      });
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

  Future<String> _fetchSession() async {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String identityId = (res as CognitoAuthSession).identityId!;
      return identityId;
  }

  void createUser() async {
    // debugPrint("Creating User");
    AuthUser? curUser;
    String? CognitoIdentityId;
    try {
      curUser = await Amplify.Auth.getCurrentUser();
      CognitoIdentityId = await _fetchSession();
      debugPrint("ASGDHRJYJHGREFWGRH");
      debugPrint(curUser.username);
      debugPrint("ASGDHRJYJHGREFWGRH");
    } on AuthException catch (e) {
      debugPrint(e.message);
    }

    final currentUser = UserModel(
        id: curUser?.userId,
        AuthUsername: curUser?.userId,
        CognitoIdentityId: CognitoIdentityId,
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

  Future<void> setDefaultUserImage() async {
    Uri imageUri = Uri.https("pbs.twimg.com",
        "/profile_images/525335533350699009/Z0Qg4rFi_400x400.jpeg");

    var imageGet = await http.get(imageUri);
    Directory imageDir = await getApplicationDocumentsDirectory();
    File image = new File(join(imageDir.path, "defaultProfile.png"));
    image.writeAsBytes(imageGet.bodyBytes).then((result) async {

      final uploadOptions = S3UploadFileOptions(
        accessLevel: StorageAccessLevel.protected,
      );
      // Upload image with the current time as the key
      final key = "profilePicture";
      final file = File(image.path);
      try {
        final UploadFileResult result =
            await Amplify.Storage.uploadFile(
            options: uploadOptions,
            local: file,
            key: key,
            onProgress: (progress) {
              print("Fraction completed: " + progress.getFractionCompleted().toString());
            }
        );
        print('Successfully uploaded image: ${result.key}');
      } on StorageException catch (e) {
        print('Error uploading image: $e');
      }
    });
  }

  Future<void> uploadImage(ProfilePageState state) async {
    // Select image from user's gallery
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('No image selected');
      return;
    }
    final uploadOptions = S3UploadFileOptions(
      accessLevel: StorageAccessLevel.protected,
    );
    // Upload image with the current time as the key
    final key = "profilePicture";
    final file = File(pickedFile.path);
    try {
      final UploadFileResult result =
      await Amplify.Storage.uploadFile(
          options: uploadOptions,
          local: file,
          key: key,
          onProgress: (progress) {
            print("Fraction completed: " + progress.getFractionCompleted().toString());
          }
      );
      print('Successfully uploaded image: ${result.key}');
      getDownloadUrl().then( (_) {
        state.newProfileImage();
      });
    } on StorageException catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<String> getUserProfilePicture(UserModel user) async {
      final uploadOptions = S3GetUrlOptions(
          accessLevel: StorageAccessLevel.protected,
          targetIdentityId: user.CognitoIdentityId
      );


      return Amplify.Storage.getUrl(key: 'profilePicture',
          options: uploadOptions).then((result) {
        return result.url;
      });

  }


  Future<String> getDownloadUrl() async {
    try {
      final uploadOptions = S3GetUrlOptions(
        accessLevel: StorageAccessLevel.protected,
      );
      final GetUrlResult result =
      await Amplify.Storage.getUrl(key: 'profilePicture',
      options: uploadOptions);
      profilePicture = NetworkImage(result.url);
      return result.url;
      // NOTE: This code is only for demonstration
      // Your debug console may truncate the printed url string
      print('Got URL: ${result.url}');
    } on StorageException catch (e) {
      print('Error getting download URL: $e');
      return '';
    }
  }
}
