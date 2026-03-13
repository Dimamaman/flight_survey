abstract class AuthEvent {}

class AuthUserLoggedIn extends AuthEvent {
  AuthUserLoggedIn(this.userId);

  final String userId;
}

class AuthUserLoggedOut extends AuthEvent {}

