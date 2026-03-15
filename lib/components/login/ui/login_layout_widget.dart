import 'package:flutter/material.dart';

import '../domain/login_state.dart';
import '../localization/login_localization_contract.dart';

abstract class LoginLayoutWidget extends StatelessWidget {
  const LoginLayoutWidget._({super.key});

  factory LoginLayoutWidget.loading({Key? key}) {
    return _LoginLayoutLoading._(key: key);
  }

  factory LoginLayoutWidget.error({Key? key, required String message}) {
    return _LoginLayoutError._(key: key, message: message);
  }

  factory LoginLayoutWidget.content({
    Key? key,
    required LoginLocalizationContract localization,
    required LoginState state,
    required ValueChanged<String> onEmailChanged,
    required ValueChanged<String> onPasswordChanged,
    required VoidCallback onSubmit,
  }) {
    return _LoginLayoutContent._(
      key: key,
      localization: localization,
      state: state,
      onEmailChanged: onEmailChanged,
      onPasswordChanged: onPasswordChanged,
      onSubmit: onSubmit,
    );
  }

  factory LoginLayoutWidget.empty({
    Key? key,
    required LoginLocalizationContract localization,
    required Function() onTap,
  }) {
    return _LoginLayoutEmpty._(localization: localization, onTap: onTap);
  }
}

class _LoginLayoutLoading extends LoginLayoutWidget {
  const _LoginLayoutLoading._({super.key}) : super._();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoginLayoutError extends LoginLayoutWidget {
  const _LoginLayoutError._({super.key, required this.message}) : super._();

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class _LoginLayoutContent extends LoginLayoutWidget {
  const _LoginLayoutContent._({
    super.key,
    required this.localization,
    required this.state,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
  }) : super._();

  final LoginLocalizationContract localization;
  final LoginState state;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localization.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(labelText: localization.emailHint),
                keyboardType: TextInputType.emailAddress,
                onChanged: onEmailChanged,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: localization.passwordHint,
                ),
                obscureText: true,
                onChanged: onPasswordChanged,
              ),
              const SizedBox(height: 24),
              if (state.errorMessage != null) ...[
                Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 8),
              ],
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: state.canSubmit ? onSubmit : null,
                  child: Text(localization.loginButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginLayoutEmpty extends LoginLayoutWidget {
  const _LoginLayoutEmpty._({
    super.key,
    required this.localization,
    required this.onTap,
  }) : super._();

  final LoginLocalizationContract localization;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(onPressed: onTap, child: Text(localization.empty)),
    );
  }
}
