import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/login_bloc.dart';
import '../domain/login_event.dart';
import '../domain/login_state.dart';
import 'login_layout_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late final LoginBloc _bloc = context.read<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.isLoading) {
          return LoginLayoutWidget.loading();
        }

        if (state.errorMessage != null && !state.canSubmit) {
          return LoginLayoutWidget.error(message: state.errorMessage!);
        }

        if (state.email.length == 5) {
          return LoginLayoutWidget.empty(
            localization: _bloc.localization,
            onTap: () => _bloc.add(LoginEmailClear()),
          );
        }

        return LoginLayoutWidget.content(
          localization: _bloc.localization,
          state: state,
          onEmailChanged: (value) => _bloc.add(LoginEmailChanged(value.trim())),
          onPasswordChanged: (value) =>
              _bloc.add(LoginPasswordChanged(value.trim())),
          onSubmit: () => _bloc.add(LoginSubmitted()),
        );
      },
    );
  }
}
