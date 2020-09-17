import 'dart:math';
import 'package:chat/models/user.dart';
import 'package:chat/services/authentication_service/authentication_repository.dart';
import 'package:chat/utils/failure.dart';
import 'package:chat/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthImpl extends AuthenticationRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> signIn({String email, String password}) async {
    try {
      final authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResult.user.uid ;
    } catch (e) {
      print("error" + e.code);
      switch (e.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          throw UnImplementedFailure();
          break;
        case "ERROR_INVALID_EMAIL":
          throw InvalidEmailException();
          break;
        case "ERROR_WRONG_PASSWORD":
          throw WrongPasswordException();
          break;
        case "ERROR_USER_NOT_FOUND":
          throw NotFoundEmailException();
          break;
        case "ERROR_USER_DISABLED":
          throw UnImplementedFailure();
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          throw UnImplementedFailure();
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          throw NetworkException();
          break;
        default:
          throw UnImplementedFailure();
      }
    }
  }

  @override
  Future<User> signUp({String username, String email, String password}) async {
    try {
      final authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      String photoUrl = _generateRandomPath();
      final user = User(
        userId: authResult.user.uid,
        name: username,
        email: email,
        imageType: ImageType.assets,
        imgUrl: photoUrl,
      );
      //await storageRepository.saveProfileUser(user);
      return user;
    } catch (e) {
      print(e.code);
      switch (e.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          throw UnImplementedFailure();
          break;
        case "ERROR_WEAK_PASSWORD":
          throw WeakPasswordException();
          break;
        case "ERROR_INVALID_EMAIL":
          throw InvalidEmailException();
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          throw EmailInUseException();
          break;
        case "ERROR_INVALID_CREDENTIAL":
          throw InvalidEmailException();
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          throw NetworkException();
          break;
        default:
          throw UnImplementedFailure();
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  @override
  Future<String> isSignIn() async {
    try {
      final user = await firebaseAuth.currentUser();
      if (user != null) {
        return user.uid ;
      } else {
        throw NoUserSignedInException();
      }
    } catch (e) {
      throw NoUserSignedInException();
    }
  }

  String _generateRandomPath() {
    final paths = Functions.getAvatarsPaths();

    int r = Random().nextInt(paths.length);
    while (paths[r] == Functions.femaleAvaterPath) {
      r = Random().nextInt(paths.length);
    }
    return paths[r];
  }

  @override
  Future<String> getUserID() async {
    try {
      return (await firebaseAuth.currentUser()).uid;
    } catch (e) {
      throw UnImplementedFailure();
    }
  }
}
