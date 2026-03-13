import 'dart:async';

import '../domain/login_action.dart';
import '../domain/login_bloc.dart';

class LoginAnalyticsListener {
  LoginAnalyticsListener(this._bloc) {
    _subscription = _bloc.actions.listen(_onAction);
  }

  final LoginBloc _bloc;
  StreamSubscription<LoginAction>? _subscription;

  void _onAction(LoginAction action) {
    // Bu yerda haqiqiy analytics SDK chaqirsa bo'ladi (Firebase va hokazo).
    // Hozircha console log bilan cheklanamiz.
    if (action is LoginNavigateToHome) {
      // ignore: avoid_print
      print('Analytics: login_success');
    } else if (action is LoginShowError) {
      // ignore: avoid_print
      print('Analytics: login_failed, message=${action.message}');
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

