import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.unauthenticated()) {
    on<AuthUserLoggedIn>(_onLoggedIn);
    on<AuthUserLoggedOut>(_onLoggedOut);
  }

  void _onLoggedIn(
    AuthUserLoggedIn event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState.authenticated(event.userId));
  }

  void _onLoggedOut(
    AuthUserLoggedOut event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.unauthenticated());
  }
}

