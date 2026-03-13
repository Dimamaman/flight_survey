class AuthState {
  const AuthState._({
    required this.isAuthenticated,
    this.userId,
  });

  const AuthState.unauthenticated() : this._(isAuthenticated: false);

  const AuthState.authenticated(String userId)
      : this._(isAuthenticated: true, userId: userId);

  final bool isAuthenticated;
  final String? userId;
}

