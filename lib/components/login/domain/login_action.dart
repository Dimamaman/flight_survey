abstract class LoginAction {}

class LoginNavigateToHome extends LoginAction {}

class LoginShowError extends LoginAction {
  LoginShowError(this.message);

  final String message;
}

