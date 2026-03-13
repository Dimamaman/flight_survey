import 'dart:async';

import 'package:flight_survey/components/login/analytics/login_analytics_listener.dart';
import 'package:flight_survey/components/login/domain/login_action.dart';
import 'package:flight_survey/components/login/domain/login_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/auth_bloc.dart';
import 'domain/auth_event.dart';

class AuthCoordinator extends StatefulWidget {
  const AuthCoordinator({super.key, required this.child});

  final Widget child;

  @override
  State<AuthCoordinator> createState() => _AuthCoordinatorState();
}

class _AuthCoordinatorState extends State<AuthCoordinator> {
  StreamSubscription<LoginAction>? _loginSubscription;
  LoginAnalyticsListener? _analyticsListener;

  @override
  void initState() {
    super.initState();

    final loginBloc = context.read<LoginBloc>();
    final authBloc = context.read<AuthBloc>();

    _loginSubscription = loginBloc.actions.listen((action) {
      if (action is LoginNavigateToHome) {
        // Bu yerda userId ni real qiymatga bog'lash mumkin.
        authBloc.add(AuthUserLoggedIn('temporary-user-id'));
      }
    });

    _analyticsListener = LoginAnalyticsListener(loginBloc);
  }

  @override
  void dispose() {
    _loginSubscription?.cancel();
    _analyticsListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
