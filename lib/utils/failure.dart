abstract class Failure {
  String code;
}

abstract class BottomPlacedException extends Failure {}

class UnImplementedFailure extends BottomPlacedException {
  final code = "An Error occured !";
}

class NetworkException extends BottomPlacedException {
  final code = "Netwrok connection error !";
}

abstract class AuthException extends Failure {}

abstract class PasswordException extends AuthException {}

abstract class EmailException extends AuthException {}

class WeakPasswordException extends PasswordException {
  final code = "password should be at least 6 characters.";
}

class WrongPasswordException extends PasswordException {
  final code = "Your password is wrong.";
}

class InvalidEmailException extends EmailException {
  final code = "Your email is invalid.";
}

class NotFoundEmailException extends EmailException {
  final code = "User with this email doesn't exist.";
}

class EmailInUseException extends EmailException {
  final code = "Email is already in use ";
}

class NoUserSignedInException extends AuthException {
  final code = "No user signed in";
}

class NoException extends Failure {}
