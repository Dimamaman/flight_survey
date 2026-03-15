import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/login_repository_contract.dart';
import '../localization/login_localization_contract.dart';
import 'login_action.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.repository, required this.localization})
    : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginEmailClear>(_onClear);
  }

  final LoginRepositoryContract repository;
  final LoginLocalizationContract localization;

  final _actionsController = StreamController<LoginAction>.broadcast();

  Stream<LoginAction> get actions => _actionsController.stream;

  void emitAction(LoginAction action) {
    if (_actionsController.isClosed) return;
    _actionsController.add(action);
  }

  @override
  Future<void> close() {
    _actionsController.close();
    return super.close();
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, errorMessage: null));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password, errorMessage: null));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await repository.login(email: state.email, password: state.password);

      emit(state.copyWith(isLoading: false, errorMessage: null));

      emitAction(LoginNavigateToHome());
    } catch (error, stackTrace) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Login error: $error\n$stackTrace');
      }

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: localization.invalidCredentials,
        ),
      );

      emitAction(LoginShowError(localization.invalidCredentials));
    }
  }

  void _onClear(LoginEmailClear event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: ""));
  }
}
