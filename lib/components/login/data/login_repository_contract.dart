abstract class LoginRepositoryContract {
  Future<void> login({required String email, required String password});
}

class MockLoginRepository implements LoginRepositoryContract {
  @override
  Future<void> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (email.length == 2 || password.isEmpty) {
      throw Exception('Invalid credentials');
    }
  }
}
