import 'package:wedding/feature/home/data/repositories/auth_repository_impl.dart';
import 'package:wedding/feature/home/domain/entities/user.dart';
import 'package:wedding/feature/home/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_usecase.g.dart';

// 吏湲덉? ?꾨떖留??섏?留??좎씪??留롮쓬
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<User> call({
    required String email,
    required String password,
  }) {
    // 1. ?뺤떇 寃利앹씠 異붽? ?????꾩엳怨?UI 寃利앹씠硫?viewmodel?먯꽌 泥섎━,
    // 鍮꾩쫰?덉뒪 洹쒖튃?대㈃ usecase 泥섎━ - ?덈? ?ㅻ㈃ api?ъ슜?댁꽌 怨꾩젙 ?뺤씤???댁빞?좊븣
    // if (email.isEmpty || password.isEmpty) {
    //   throw DomainException('?대찓?쇨낵 鍮꾨?踰덊샇瑜?紐⑤몢 ?낅젰?댁빞 ?⑸땲??');
    // }
    //
    // // ?대찓???뺤떇 寃利?
    // if (!email.contains('@')) {
    //   throw DomainException('?대찓???뺤떇???щ컮瑜댁? ?딆뒿?덈떎.');
    // }

    // 2. ?щ윭 由ы꽩 媛믪쓣 議고빀?섎뒗 寃쎌슦
    // final profile = await _profileRepository.fetchProfile(user.id);
    //
    // return (user, profile);


    return _authRepository.login(
      email: email,
      password: password,
    );
  }
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(repo);
}
