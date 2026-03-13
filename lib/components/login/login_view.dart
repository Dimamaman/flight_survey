import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_coordinator.dart';
import '../auth/domain/auth_bloc.dart';
import 'data/login_repository_contract.dart';
import 'domain/login_bloc.dart';
import 'localization/login_localization_contract.dart';
import 'localization/login_localization_impl.dart';
import 'login_coordinator.dart';
import 'ui/login_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  LoginRepositoryContract _createRepository(BuildContext context) {
    // Replace with real implementation when backend is ready.
    return MockLoginRepository();
  }

  LoginLocalizationContract _createLocalization(BuildContext context) {
    // Replace with app-level localization adapter if needed.
    return const DefaultLoginLocalization();
  }

  LoginBloc _createBloc(BuildContext context) {
    return LoginBloc(
      repository: _createRepository(context),
      localization: _createLocalization(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: _createBloc,
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
      ],
      child: const AuthCoordinator(
        child: LoginCoordinator(
          child: LoginWidget(),
        ),
      ),
    );
  }
}
