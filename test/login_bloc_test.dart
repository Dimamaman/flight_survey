import 'package:flight_survey/components/login/data/login_repository_contract.dart';
import 'package:flight_survey/components/login/domain/login_bloc.dart';
import 'package:flight_survey/components/login/domain/login_event.dart';
import 'package:flight_survey/components/login/localization/login_localization_contract.dart';
import 'package:flight_survey/components/login/ui/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock repository — muvaffaqiyat yoki xato qaytaradi
class MockLoginRepository implements LoginRepositoryContract {
  MockLoginRepository({this.shouldFail = false});
  final bool shouldFail;

  @override
  Future<void> login({required String email, required String password}) async {
    if (shouldFail) throw Exception('Invalid credentials');
  }
}

// Mock localization
class MockLoginLocalization implements LoginLocalizationContract {
  @override
  String get title => 'Login';
  @override
  String get emailHint => 'Email';
  @override
  String get passwordHint => 'Password';
  @override
  String get loginButton => 'Login';
  @override
  String get loading => 'Loading...';
  @override
  String get unknownError => 'Unknown error';
  @override
  String get invalidCredentials => 'Invalid credentials';
  @override
  String get empty => '';
}

void main() {
  group('LoginBloc — CONTEXT KERAK EMAS (oddiy unit test)', () {
    test(
      'LoginEmailChanged — blocni to\'g\'ridan-to\'g\'ri yaratib event yuboramiz',
      () async {
        final bloc = LoginBloc(
          repository: MockLoginRepository(),
          localization: MockLoginLocalization(),
        );

        bloc.add(LoginEmailChanged('test@mail.com'));
        await Future<void>.delayed(Duration.zero);

        expect(bloc.state.email, 'test@mail.com');
        await bloc.close();
      },
    );

    test('LoginPasswordChanged — context yo\'q, faqat bloc.add()', () async {
      final bloc = LoginBloc(
        repository: MockLoginRepository(),
        localization: MockLoginLocalization(),
      );

      bloc.add(LoginPasswordChanged('secret123'));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.password, 'secret123');
      await bloc.close();
    });

    test('LoginSubmitted muvaffaqiyat — repository success', () async {
      final bloc = LoginBloc(
        repository: MockLoginRepository(shouldFail: false),
        localization: MockLoginLocalization(),
      );
      bloc.add(LoginEmailChanged('a@b.com'));
      bloc.add(LoginPasswordChanged('pass'));
      await Future<void>.delayed(Duration.zero);

      bloc.add(LoginSubmitted());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.isLoading, false);
      expect(bloc.state.errorMessage, isNull);
      await bloc.close();
    });

    test('LoginSubmitted xato — repository throw', () async {
      final bloc = LoginBloc(
        repository: MockLoginRepository(shouldFail: true),
        localization: MockLoginLocalization(),
      );
      bloc.add(LoginEmailChanged('a@b.com'));
      bloc.add(LoginPasswordChanged('pass'));
      await Future<void>.delayed(Duration.zero);

      bloc.add(LoginSubmitted());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.isLoading, false);
      expect(bloc.state.errorMessage, 'Invalid credentials');
      await bloc.close();
    });

    // Context null bo'lganda: LoginEmailClear chaqirilganda _onClear ichida
    // context! null check xatosi beradi. Ko'rish uchun bitta testni ishga tushiring:
    //   flutter test test/login_bloc_test.dart --plain-name "LoginEmailClear — context null"
    test(
      'LoginEmailClear — context null bo\'lganda xato (context ishlatiladi)',
      () async {
        final bloc = LoginBloc(
          repository: MockLoginRepository(),
          localization: MockLoginLocalization(),
          context: null,
        );
        bloc.add(LoginEmailChanged('test@mail.com'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(LoginEmailClear());
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await bloc.close();
      },
      skip: false,
    ); // skip: true — bu test ataylab fail qiladi (xatoni ko'rsatish uchun)
  });

  group(
    'LoginBloc — CONTEXT KERAK (widget test, blocni context orqali olamiz)',
    () {
      testWidgets(
        'Blocni context.read<LoginBloc>() orqali olamiz — context bor',
        (WidgetTester tester) async {
          late LoginBloc blocFromContext;
          final repository = MockLoginRepository();
          final localization = MockLoginLocalization();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(
                    repository: repository,
                    localization: localization,
                    context: context,
                  ),
                  child: Builder(
                    builder: (context) {
                      blocFromContext = context.read<LoginBloc>();
                      return const LoginWidget();
                    },
                  ),
                ),
              ),
            ),
          );

          blocFromContext.add(LoginEmailChanged('from@context.com'));
          await tester.pump();

          expect(blocFromContext.state.email, 'from@context.com');
        },
      );
    },
  );
}
