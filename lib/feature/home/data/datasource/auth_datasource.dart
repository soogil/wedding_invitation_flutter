import 'package:wedding/core/api/dio.dart';
import 'package:wedding/feature/home/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_datasource.g.dart';

abstract class AuthDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

/// ?덉젣??Fake 援ы쁽 (?뚯뒪???섑뵆??
class AuthDatasourceImpl implements AuthDataSource {
  AuthDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/home/main',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}

@riverpod
AuthDataSource authDataSource(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthDatasourceImpl(dio);
}
