import 'package:wedding/feature/home/data/repositories/auth_repository_impl.dart';
import 'package:wedding/feature/home/domain/entities/user.dart';
import 'package:wedding/feature/home/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding/feature/home/domain/usecase/login_usecase.dart';


class FakeAuthRepository implements AuthRepository {
  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    return User(
      id: '123',
      email: email,
      name: 'Test User',
    );
  }
}

void main() {
  group('LoginUseCase', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          // ?꾨찓???덉씠?댁쓽 authRepositoryProvider瑜?Fake濡?援먯껜
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
      );
      addTearDown(container.dispose);
    });

    test('?대찓??鍮꾨?踰덊샇濡?濡쒓렇?명븯硫?User瑜?諛섑솚?쒕떎', () async {
      // given
      final useCase = container.read(loginUseCaseProvider);

      // when
      final user = await useCase(
        email: 'test@test.com',
        password: '1234',
      );

      // then
      expect(user.id, '123');
      expect(user.email, 'test@test.com');
      expect(user.name, 'Test User');
    });

    test('?대찓?쇱씠 鍮꾩뼱 ?덉쑝硫??덉쇅瑜??섏쭊??(鍮꾩쫰?덉뒪 寃利??덉떆)', () async {
      final useCase = container.read(loginUseCaseProvider);

      expect(
            () => useCase(email: '', password: '1234'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
