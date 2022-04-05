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
import 'edit_my_profile_page.dart';

class AmplifyState {
  bool isAmplifyConfigured = false;
  bool loggedIn = false;
  final picker = ImagePicker();
  late NetworkImage profilePicture;
  late String? name;
  late String? email;
  late String? gender;
  late String? birthdate;
  late String? number;
  late MyHomePageState homePageState;

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
          await Amplify.Auth.getCurrentUser();
          loggedIn = true;
          getDownloadUrl().then((result) {
            profilePicture = NetworkImage(result);
          });
          return;
        }
      } on SignedOutException {
        loggedIn = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginScreen(key: null, amplifyState: amplifyState)));
        return;
      }
    } on AmplifyAlreadyConfiguredException {
      debugPrint(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  Future<String> signUp(String email, String password, String name) async {
    try {
      Map<CognitoUserAttributeKey, String> userInfo = {
        CognitoUserAttributeKey.name: name,
      };

      await Amplify.Auth.signUp(
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

  Future<String> resendSignUp(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return "SuccessfulResendSignup";
    } on AuthException catch (e) {
      debugPrint("In AuthException for resendSignUp");
      debugPrint(e.message);
      return e.message;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
      return "SuccessfulCodeSend";
    } on AuthException catch (e) {
      debugPrint("In AuthException for resetPassword");
      debugPrint(e.message);
      return e.message;
    }
  }

  Future<String> resetPasswordConfirm(
      String email, String code, String password) async {
    try {
      await Amplify.Auth.confirmResetPassword(
          username: email, newPassword: password, confirmationCode: code);
      return "SuccessfulPasswordReset";
    } on AuthException catch (e) {
      debugPrint("In AuthException for resetPasswordConfirm");
      debugPrint(e.message);
      return e.message;
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      loggedIn = true;

      getDownloadUrl().then((result) {
        profilePicture = NetworkImage(result);
      });
      return "SuccessfulLogin";
    } on AuthException catch (e) {
      debugPrint("In AuthException for loginUser");
      debugPrint(e.message);
      loggedIn = false;
      return e.message;
    }
  }

  Future<String> confirmSignUp(String email, String confirmation) async {
    try {
      await Amplify.Auth.confirmSignUp(
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
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsersNM() async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;

      List<UserModel> allUsers = await Amplify.DataStore.query(
          UserModel.classType,
          where: UserModel.AUTHUSERNAME.ne(activeID));

      return (allUsers);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
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
    AuthUser? curUser;
    String? cognitoIdentityId;
    try {
      curUser = await Amplify.Auth.getCurrentUser();
      cognitoIdentityId = await _fetchSession();
      debugPrint("ASGDHRJYJHGREFWGRH");
      debugPrint(curUser.username);
      debugPrint("ASGDHRJYJHGREFWGRH");
    } on AuthException catch (e) {
      debugPrint(e.message);
    }

    final currentUser = UserModel(
        id: curUser?.userId,
        AuthUsername: curUser?.userId,
        CognitoIdentityId: cognitoIdentityId,
        Name: name,
        Gender: gender,
        Email: email,
        Birthday: birthdate,
        PhoneNumber: number);

    try {
      await Amplify.DataStore.save(currentUser);

      debugPrint('Saved ${currentUser.toString()}');
    } catch (e) {
      debugPrint(e.toString());
    }
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
      debugPrint(e.toString());
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
      debugPrint(e.toString());
    }
  }

  Future<List<Location>> getAllLocations() async {
    try {
      List<Location> locations =
          await Amplify.DataStore.query(Location.classType);

      return (locations);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Location> getFirstLocation() async {
    try {
      List<Location> locations =
          await Amplify.DataStore.query(Location.classType);

      return (locations.first);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
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
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<UserModel> getUserfromID(String? userID) async {
    try {
      final theseUsers = await Amplify.DataStore.query(UserModel.classType,
          where: UserModel.AUTHUSERNAME.eq(userID));

      if (theseUsers.isEmpty) {
        debugPrint("No objects with ID: $userID");
        // return null;
      }

      final thisUser = theseUsers.first;

      return thisUser;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
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

      debugPrint('Updated user profile to ${updatedUser.toString()}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteProfile() async {
    try {
      final userToBeDeleted = await getUserProfile();

      await Amplify.DataStore.delete(userToBeDeleted);

      debugPrint('Deleted user with Name: ${userToBeDeleted.Name}');
      debugPrint('Deleted user with ID: ${userToBeDeleted.id}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Match>> getMyMatches() async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final isUser = Match.USER1ID.eq(activeID).or(Match.USER2ID.eq(activeID));
      final myMatches = await Amplify.DataStore.query(Match.classType,
          where: Match.USER1CHECK
              .eq(true)
              .and(Match.USER2CHECK.eq(true))
              .and(isUser));

      if (myMatches.isEmpty) {
        debugPrint("You got no matches: $activeID");
        // return null;
      }

      return myMatches;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>> getMyMatchesUsers() async {
    try {
      List<UserModel> matchUsers = [];
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final isUser = Match.USER1ID.eq(activeID).or(Match.USER2ID.eq(activeID));
      final myMatches = await Amplify.DataStore.query(Match.classType,
          where: Match.USER1CHECK
              .eq(true)
              .and(Match.USER2CHECK.eq(true))
              .and(isUser));

      if (myMatches.isEmpty) {
        debugPrint("You got no matches: $activeID");
        return matchUsers;
      }
      for (var element in myMatches) {
        if (element.User1ID != activeID) {
          getUserfromID(element.User1ID).then((value) => matchUsers.add(value));
        } else if (element.User2ID != activeID) {
          getUserfromID(element.User2ID).then((value) => matchUsers.add(value));
        }
      }
      return matchUsers;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<Match>> getMyAdmirers() async {
    try {
      AuthUser? curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;

      final user2Null =
          Match.USER2ID.eq(activeID).and(Match.USER2CHECK.eq(null));

      final myAdmirers = await Amplify.DataStore.query(Match.classType,
          where: Match.USER1CHECK.eq(true).and(user2Null));

      if (myAdmirers.isEmpty) {
        debugPrint("You got no matches: $activeID");
        // return null;
      }

      return myAdmirers;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>> getMyAdmirersUsers() async {
    try {
      List<UserModel> admirerUsers = [];
      AuthUser? curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;

      final user2Null =
          Match.USER2ID.eq(activeID).and(Match.USER2CHECK.eq(null));

      final myAdmirers = await Amplify.DataStore.query(Match.classType,
          where: Match.USER1CHECK.eq(true).and(user2Null));

      if (myAdmirers.isEmpty) {
        debugPrint("You got no matches: $activeID");
        // return null;
      }
      for (var element in myAdmirers) {
        if (element.User1ID != activeID) {
          getUserfromID(element.User1ID)
              .then((value) => admirerUsers.add(value));
        } else if (element.User2ID != activeID) {
          getUserfromID(element.User2ID)
              .then((value) => admirerUsers.add(value));
        }
      }
      return admirerUsers;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<Match>> getMyRequests() async {
    try {
      AuthUser? curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;

      final user1True =
          Match.USER1ID.eq(activeID).and(Match.USER1CHECK.eq(true));

      final myRequests = await Amplify.DataStore.query(Match.classType,
          where: Match.USER2CHECK.eq(null).and(user1True));

      if (myRequests.isEmpty) {
        debugPrint("You got no matches: $activeID");
        // return null;
      }

      return myRequests;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>> getMyRequestsUsers() async {
    try {
      List<UserModel> requestUsers = [];
      AuthUser? curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;

      final user1True =
          Match.USER1ID.eq(activeID).and(Match.USER1CHECK.eq(true));

      final myRequests = await Amplify.DataStore.query(Match.classType,
          where: Match.USER2CHECK.eq(null).and(user1True));

      if (myRequests.isEmpty) {
        debugPrint("You got no matches: $activeID");
        // return null;
      }
      for (var element in myRequests) {
        if (element.User1ID != activeID) {
          getUserfromID(element.User1ID)
              .then((value) => requestUsers.add(value));
        } else if (element.User2ID != activeID) {
          getUserfromID(element.User2ID)
              .then((value) => requestUsers.add(value));
        }
      }
      return requestUsers;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  void approveRequest(Match curMatch) async {
    try {
      Match updatedMatch = curMatch;

      updatedMatch = curMatch.copyWith(User2Check: true);
      await Amplify.DataStore.save(updatedMatch);
      debugPrint('Approved Match');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void declineRequest(Match curMatch) async {
    try {
      Match updatedMatch = curMatch;

      updatedMatch = curMatch.copyWith(User2Check: false);
      await Amplify.DataStore.save(updatedMatch);
      debugPrint('Declined Match');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void removeRequest(Match curMatch) async {
    try {
      Match updatedMatch = curMatch;

      updatedMatch = curMatch.copyWith(User1Check: false);
      await Amplify.DataStore.save(updatedMatch);
      debugPrint('Declined Match');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void unMatch(Match curMatch) async {
    try {
      final matchToBeDeleted = curMatch;

      await Amplify.DataStore.delete(matchToBeDeleted);

      // debugPrint('Deleted match with Name: ${matchToBeDeleted.User1Name}');
      // debugPrint('Deleted match with Name: ${matchToBeDeleted.User2Name}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void createMatch(UserModel viewUser) async {
    getUserProfile().then((curUser) {
      debugPrint('HERE XXXXX');
      debugPrint(curUser.Name.toString());
      debugPrint(viewUser.Name.toString());

      if (viewUser.AuthUsername == curUser.id) {
        return;
      }
      matchExist(viewUser).then((matchExists) {
        if (matchExists) {
          debugPrint("MATCH ALREADY EXISTS");
          return;
        }

        final newMatch = Match(
          User1Name: curUser.Name,
          User1ID: curUser.AuthUsername,
          User1Check: true,
          User2Name: viewUser.Name,
          User2ID: viewUser.AuthUsername,
          // Location: location.id,
          // User2Check: true,
        );

        try {
          Amplify.DataStore.save(newMatch);
          debugPrint(
              'New Match between ${newMatch.User1Name} and ${newMatch.User2Name}');
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    });
  }

  Future<bool> matchExist(UserModel viewUser) async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final isUserA = Match.USER1ID
          .eq(activeID)
          .and(Match.USER2ID.eq(viewUser.AuthUsername));
      final isUserB = Match.USER1ID
          .eq(viewUser.AuthUsername)
          .and(Match.USER2ID.eq(activeID));

      final myMatches = await Amplify.DataStore.query(Match.classType,
          where: isUserA.or(isUserB));

      if (myMatches.isEmpty) {
        debugPrint("Match Button");
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Match> getMatch(UserModel viewUser) async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final isUserA = Match.USER1ID
          .eq(activeID)
          .and(Match.USER2ID.eq(viewUser.AuthUsername));
      final isUserB = Match.USER1ID
          .eq(viewUser.AuthUsername)
          .and(Match.USER2ID.eq(activeID));

      final myMatches = await Amplify.DataStore.query(Match.classType,
          where: isUserA.or(isUserB));

      if (myMatches.isEmpty) {
        debugPrint("No Match");
      }
      return myMatches.first;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  void deleteMatches(UserModel viewUser) async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final isUserA = Match.USER1ID
          .eq(activeID)
          .and(Match.USER2ID.eq(viewUser.AuthUsername));
      final isUserB = Match.USER1ID
          .eq(viewUser.AuthUsername)
          .and(Match.USER2ID.eq(activeID));

      final both = isUserA.or(isUserB);
      final myMatches =
          await Amplify.DataStore.query(Match.classType, where: both);
      if (myMatches.isEmpty) {
        debugPrint("No Matches");
        return;
      }

      for (var element in myMatches) {
        debugPrint('Matches to Delete XXX');
        debugPrint(element.User1Name);
        debugPrint(element.User2Name);
        try {
          await Amplify.DataStore.delete(element,
              where: Match.USER1ID
                  .eq(element.User1ID)
                  .and(Match.USER2ID.eq(element.User2ID)));
          debugPrint('Deleted a match');
        } on DataStoreException catch (e) {
          debugPrint('Delete failed: $e');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<String> getMatchStatus(UserModel viewUser) async {
    try {
      AuthUser? curUser;
      curUser = await Amplify.Auth.getCurrentUser();
      final activeID = curUser.userId;
      final isUserA = Match.USER1ID
          .eq(activeID)
          .and(Match.USER2ID.eq(viewUser.AuthUsername));
      final isUserB = Match.USER1ID
          .eq(viewUser.AuthUsername)
          .and(Match.USER2ID.eq(activeID));
      final myMatches = await Amplify.DataStore.query(Match.classType,
          where: isUserA.or(isUserB));

      if (myMatches.isEmpty) {
        debugPrint("No Matches (Could be your own profile)");
        return ("NoMatch");
      }
      Match curMatch = myMatches.first;
      if (curMatch.User1Check == true && curMatch.User2Check == true) {
        return ("Match");
      } else if (curMatch.User1ID == activeID &&
          curMatch.User1Check == true &&
          (curMatch.User2Check == false || curMatch.User2Check == null)) {
        return ("Outgoing");
      } else if (curMatch.User2ID == activeID &&
          curMatch.User2Check == true &&
          (curMatch.User1Check == false || curMatch.User1Check == null)) {
        return ("Outgoing");
      } else if (curMatch.User1ID == activeID &&
          curMatch.User2Check == true &&
          (curMatch.User1Check == false || curMatch.User1Check == null)) {
        return ("Incoming");
      } else if (curMatch.User2ID == activeID &&
          curMatch.User1Check == true &&
          (curMatch.User2Check == false || curMatch.User2Check == null)) {
        return ("Incoming");
      } else if ((curMatch.User1Check == false ||
                  curMatch.User1Check == null) ==
              true &&
          (curMatch.User2Check == false || curMatch.User2Check == null)) {
        return ("NoLongerMatched");
      }

      return ("Temp Case");
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  void clearLocalDataStore() async {
    try {
      debugPrint("WARNING: Clearing DB");
      await Amplify.DataStore.clear();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setDefaultUserImage() async {
    Uri imageUri = Uri.https("pbs.twimg.com",
        "/profile_images/525335533350699009/Z0Qg4rFi_400x400.jpeg");

    var imageGet = await http.get(imageUri);
    Directory imageDir = await getApplicationDocumentsDirectory();
    File image = File(join(imageDir.path, "defaultProfile.png"));
    image.writeAsBytes(imageGet.bodyBytes).then((result) async {
      final uploadOptions = S3UploadFileOptions(
        accessLevel: StorageAccessLevel.protected,
      );
      // Upload image with the current time as the key
      const key = "profilePicture";
      final file = File(image.path);
      try {
        final UploadFileResult result = await Amplify.Storage.uploadFile(
            options: uploadOptions,
            local: file,
            key: key,
            onProgress: (progress) {
              debugPrint("Fraction completed: " +
                  progress.getFractionCompleted().toString());
            });
        debugPrint('Successfully uploaded image: ${result.key}');
      } on StorageException catch (e) {
        debugPrint('Error uploading image: $e');
      }
    });
  }

  Future<void> uploadImage(EditMyProfilePageState state) async {
    // Select image from user's gallery
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      debugPrint('No image selected');
      return;
    }
    final uploadOptions = S3UploadFileOptions(
      accessLevel: StorageAccessLevel.protected,
    );
    // Upload image with the current time as the key
    const key = "profilePicture";
    final file = File(pickedFile.path);
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          options: uploadOptions,
          local: file,
          key: key,
          onProgress: (progress) {
            debugPrint("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      debugPrint('Successfully uploaded image: ${result.key}');
      getDownloadUrl().then((_) {
        state.newProfileImage();
      });
    } on StorageException catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }

  Future<String> getUserProfilePicture(UserModel user) async {
    final uploadOptions = S3GetUrlOptions(
        accessLevel: StorageAccessLevel.protected,
        targetIdentityId: user.CognitoIdentityId);

    return Amplify.Storage.getUrl(key: 'profilePicture', options: uploadOptions)
        .then((result) {
      return result.url;
    });
  }

  Future<String> getDownloadUrl() async {
    try {
      final uploadOptions = S3GetUrlOptions(
        accessLevel: StorageAccessLevel.protected,
      );
      final GetUrlResult result = await Amplify.Storage.getUrl(
          key: 'profilePicture', options: uploadOptions);
      profilePicture = NetworkImage(result.url);
      return result.url;
      // NOTE: This code is only for demonstration
      // Your debug console may truncate the debugPrint(e.toString())d url string
    } on StorageException catch (e) {
      debugPrint('Error getting download URL: $e');
      return '';
    }
  }
}
