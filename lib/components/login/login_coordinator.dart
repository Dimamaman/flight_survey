import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/login_action.dart';
import 'domain/login_bloc.dart';

class LoginCoordinator extends StatefulWidget {
  const LoginCoordinator({super.key, required this.child});

  final Widget child;

  @override
  State<LoginCoordinator> createState() => _LoginCoordinatorState();
}

class _LoginCoordinatorState extends State<LoginCoordinator> {
  StreamSubscription<LoginAction>? _subscription;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<LoginBloc>();
    _subscription = bloc.actions.listen(_onAction);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onAction(LoginAction action) {
    if (!mounted) return;
    if (action is LoginNavigateToHome) {
      // For now simply pop, can be replaced with real navigation.
      Navigator.of(context).maybePop();
    } else if (action is LoginShowError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(action.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return widget.child;
      },
    );
  }
}
