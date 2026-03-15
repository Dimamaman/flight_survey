abstract class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  LoginEmailChanged(this.email);

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  LoginPasswordChanged(this.password);

  final String password;
}

class LoginSubmitted extends LoginEvent {}

class LoginEmailClear extends LoginEvent {}
