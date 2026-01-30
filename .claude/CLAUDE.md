# 🎯 Soogil Flutter MVP Architecture Agent Guide
## 프로젝트 컨텍스트
이 프로젝트는 MVP (Passive View) + Flutter Hooks + Riverpod 패턴을 사용하는 Flutter 앱입니다. 
모든 코드 생성 및 수정 시 **"UI는 스스로 판단하지 않고 명령을 수행하며, 프레젠터가 모든 제어권을 갖는다"**는 대원칙을 준수해야 합니다.

## 아키텍처 규칙폴더 구조 (Feature 기반)

```
lib/
├── core/                     # 공통 모듈 (api, router, theme, util 등)
└── feature/                  # 기능별 모듈
└── {feature_name}/
├── domain/           # 비즈니스 명세
│   ├── entities/     # 도메인에서 사용될 model의 가공 entities
│   ├── usecase/      # 도메인에서 처리될 비즈니스 로직
│   └── repositories/ # 도메인에서 사용될 model의 가공 처리하는 리파지토리
├── data/             # 데이터 레이어
│   ├── datasource/   # Remote/Local DataSource
│   ├── models/       # DTO (Freezed 사용)
│   └── repositories/ # Repository 구현체
└── presentation/     # 표현 레이어
├── {feature_name}_presenter_impl.dart # 비즈니스 로직 구현
├── {feature_name}_state.dart          # (선택) Presenter용 데이터 클래스
└── view/
├── {feature_name}_page.dart       # UI 위젯 (HookConsumerWidget)
└── {feature_name}_delegate.dart   # View 인터페이스 구현체 (Bridge)
```

## 레이어별 책임
역할,책임,비고
View (Page),"UI 레이아웃, 사용자 입력 전달",Passive View (판단 로직 없음)
Delegate,Presenter의 명령을 실제 UI 동작으로 번역,"Hooks 상태 업데이트, SnackBar 등"
Presenter,"비즈니스 로직, 뷰 제어 명령(Command)",순수 Dart (Flutter 의존성 없음)
Contract,뷰와 프레젠터 간의 약속 정의,추상 인터페이스 

## 코드 컨벤션

1. Contract 패턴 (Interface First)
   모든 기능 구현 전 반드시 계약을 먼저 정의합니다.

```dart
// domain/auth_contract.dart
abstract interface class AuthView {
void showLoading();
void hideLoading();
void showMessage(String message);
void navigateToMain();
}

abstract interface class AuthPresenter {
void setView(AuthView view);
void login(String email, String password);
void dispose();
}
```

2. Presenter 구현 (Command-driven)
   프레젠터는 상태를 관찰하게 하지 않고, 뷰의 메서드를 직접 호출합니다.

```dart
// presentation/auth_presenter_impl.dart
class AuthPresenterImpl implements AuthPresenter {
final AuthRepository _repository;
AuthView? _view;

AuthPresenterImpl(this._repository);

@override
void setView(AuthView view) => _view = view;

@override
void login(String email, String password) async {
_view?.showLoading();
final result = await _repository.login(email, password);
_view?.hideLoading();

    result.fold(
      (failure) => _view?.showMessage(failure.message),
      (success) => _view?.navigateToMain(),
    );
}

@override
void dispose() => _view = null;
}

// Provider 등록 (Riverpod)
@riverpod
AuthPresenter authPresenter(Ref ref) {
final repository = ref.watch(authRepositoryProvider);
return AuthPresenterImpl(repository);
}
```

3. View Delegate (The Bridge)
   Hooks 상태와 프레젠터를 연결하는 대리인 클래스입니다.

```dart
// presentation/view/auth_delegate.dart
class AuthDelegate implements AuthView {
final BuildContext context;
final ValueNotifier<bool> loadingState;

AuthDelegate({required this.context, required this.loadingState});

@override
void showLoading() => loadingState.value = true;

@override
void hideLoading() => loadingState.value = false;

@override
void showMessage(String msg) =>
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

@override
void navigateToMain() => context.go('/main');
}
```

4. Page 구현 (HookConsumerWidget)
   useMemoized와 useEffect를 사용하여 생명주기를 관리합니다.

```dart
// presentation/view/auth_page.dart
class AuthPage extends HookConsumerWidget {
@override
Widget build(BuildContext context, WidgetRef ref) {
final presenter = ref.watch(authPresenterProvider);
final isLoading = useState(false);

    // Delegate 인스턴스 박제
    final view = useMemoized(() => AuthDelegate(
      context: context, 
      loadingState: isLoading,
    ));

    // 생명주기 연결
    useEffect(() {
      presenter.setView(view);
      return presenter.dispose;
    }, [presenter]);

    return Scaffold(
      body: isLoading.value ? const Loader() : LoginForm(onLogin: presenter.login),
    );
}
}
```

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

## 화면쪽 테스트 코드

```dart
void main() {
  test('로그인 시 로딩바가 표시되고 사라져야 함', () async {
    final mockView = MockAuthView(); // mockito 또는 mocktail 사용
    final presenter = AuthPresenterImpl(mockRepo);
    presenter.setView(mockView);

    await presenter.login('id', 'pw');

    // 행위 검증 (Behavior Verification)
    verify(mockView.showLoading()).called(1);
    verify(mockView.hideLoading()).called(1);
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
6. **Passive View 준수**: 위젯(Page) 내부에서 if 문을 사용해 비즈니스 결정을 내리지 마십시오.
7. **No Context in Presenter**: Presenter 메서드 파라미터로 BuildContext를 전달하는 행위는 엄격히 금지됩니다.
8. **Implicit Update 금지**: isLoading.value = true를 위젯에서 직접 수행하지 마십시오. 반드시 프레젠터의 명령(view.showLoading())을 통해 수행되어야 합니다.
9. **Contract 기반 설계**: 모든 로직 생성 전 contract.dart를 먼저 업데이트하거나 생성하십시오.