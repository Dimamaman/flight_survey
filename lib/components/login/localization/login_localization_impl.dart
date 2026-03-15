import 'login_localization_contract.dart';

class DefaultLoginLocalization implements LoginLocalizationContract {
  const DefaultLoginLocalization();

  @override
  String get title => 'Sign in';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get loading => 'Loading...';

  @override
  String get unknownError => 'Something went wrong';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get empty => "Empty";
}
