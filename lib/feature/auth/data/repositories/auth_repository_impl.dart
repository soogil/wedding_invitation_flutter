import 'package:wedding/feature/auth/data/datasource/auth_datasource.dart';
import 'package:wedding/feature/auth/data/models/user_model.dart';
import 'package:wedding/feature/auth/domain/entities/user.dart';
import 'package:wedding/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

// ?꾨찓?멸낵 data ?곌껐 ?댁＜??援ы쁽
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final model = await _dataSource.login(email: email, password: password);

    return model.toEntity();
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final remote = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(remote);
}
