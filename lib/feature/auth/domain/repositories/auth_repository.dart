import 'package:wedding/feature/auth/domain/entities/user.dart';

// ?명꽣?섏씠?ㅻ쭔 援ы쁽 ?대뼡 湲곕뒫???꾩슂?쒖?留?
abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });
}
