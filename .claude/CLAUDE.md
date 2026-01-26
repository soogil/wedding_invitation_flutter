# Soogil Flutter 프로젝트 커스텀 에이전트 가이드

## 프로젝트 컨텍스트

이 프로젝트는 **Clean Architecture + Riverpod** 패턴을 사용하는 Flutter 앱입니다.
모든 코드 생성 및 수정 시 아래 규칙을 준수해야 합니다.

---

## 아키텍처 규칙

### 폴더 구조 (Feature 기반)

```
lib/
├── core/                     # 공통 모듈
│   ├── api/                  # Dio 클라이언트, 예외 처리
│   ├── router/               # GoRouter 설정
│   ├── theme/                # 색상, 타이포그래피
│   ├── config/               # 환경 설정
│   └── util/                 # 유틸리티 함수
│
└── feature/                  # 기능별 모듈
    └── {feature_name}/
        ├── data/
        │   ├── datasource/   # RemoteDataSource, LocalDataSource
        │   ├── models/       # DTO (Freezed 사용)
        │   └── repositories/ # Repository 구현체
        ├── domain/
        │   ├── entities/     # 순수 Dart 엔티티
        │   ├── repositories/ # Repository 인터페이스 (abstract class)
        │   └── usecase/      # 비즈니스 로직
        └── presentation/
            └── {screen_name}/ # 화면별 위젯
```

### 레이어별 책임

| 레이어 | 책임 | 의존성 |
|--------|------|--------|
| **Presentation** | UI, 상태관리 | Domain |
| **Domain** | 비즈니스 로직, 엔티티 | 없음 (순수 Dart) |
| **Data** | API 호출, DTO 변환 | Domain |

---

## 코드 컨벤션

### 네이밍 규칙

```dart
// 파일명: snake_case
user_model.dart
auth_repository.dart
login_usecase.dart

// 클래스명: PascalCase
class UserModel {}
class AuthRepository {}
class LoginUseCase {}

// Provider: camelCase + Provider 접미사
@riverpod
AuthRepository authRepository(Ref ref) => ...
// 생성되는 Provider: authRepositoryProvider
```

### Riverpod Provider 패턴

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{file_name}.g.dart';

@riverpod
ClassName className(Ref ref) {
  final dependency = ref.watch(dependencyProvider);
  return ClassName(dependency);
}
```

### Freezed Model 패턴

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{model_name}.freezed.dart';
part '{model_name}.g.dart';

@freezed
sealed class ModelName with _$ModelName {
  const factory ModelName({
    required String id,
    required String name,
  }) = _ModelName;

  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);
}

// Entity 변환 Extension
extension ModelNameExtension on ModelName {
  EntityName toEntity() => EntityName(id: id, name: name);
}
```

### Entity 패턴 (순수 Dart)

```dart
class EntityName {
  final String id;
  final String name;

  const EntityName({
    required this.id,
    required this.name,
  });
}
```

### Repository 패턴

```dart
// Domain Layer - Interface
abstract class FeatureRepository {
  Future<Entity> getData();
}

// Data Layer - Implementation
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureDataSource _dataSource;

  FeatureRepositoryImpl(this._dataSource);

  @override
  Future<Entity> getData() async {
    final model = await _dataSource.fetchData();
    return model.toEntity();
  }
}
```

### UseCase 패턴

```dart
class FeatureUseCase {
  final FeatureRepository _repository;

  FeatureUseCase(this._repository);

  Future<Entity> call({required String param}) {
    // 비즈니스 로직 (유효성 검사 등)
    return _repository.getData();
  }
}
```

---

## 테스트 패턴

### Fake 객체를 통한 의존성 주입

```dart
class FakeRepository implements Repository {
  @override
  Future<Entity> getData() async {
    return Entity(id: 'fake', name: 'Fake Data');
  }
}

void main() {
  group('UseCaseTest', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          repositoryProvider.overrideWithValue(FakeRepository()),
        ],
      );
      addTearDown(container.dispose);
    });

    test('should return data', () async {
      final useCase = container.read(useCaseProvider);
      final result = await useCase();
      expect(result.id, 'fake');
    });
  });
}
```

---

## 자주 사용하는 명령어

```bash
# 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 코드 생성 (watch 모드)
dart run build_runner watch --delete-conflicting-outputs

# 테스트 실행
flutter test

# 앱 실행
flutter run
```

---

## 주의사항

1. **Domain Layer는 순수 Dart**: Flutter/외부 패키지 import 금지
2. **Model → Entity 변환**: Data Layer에서 Extension으로 처리
3. **Provider는 코드 생성**: `@riverpod` 어노테이션 + `part` 선언 필수
4. **Freezed는 sealed class**: `@freezed sealed class` 형태 사용
5. **한글 주석 허용**: 비즈니스 로직 설명 시 한글 주석 사용 가능
