#!/usr/bin/env bash

# 사용법:
# ./init_project.ps1 "My App Name" com.company.myapp my_app
# "앱이름" 번들ID pubspec_name 순서

set -e

APP_NAME=$1
BUNDLE_ID=$2
PROJECT_NAME=$3

if [ -z "$APP_NAME" ] || [ -z "$BUNDLE_ID" ] || [ -z "$PROJECT_NAME" ]; then
  echo "❌ 사용법: ./init.sh \"앱이름\" com.company.appname project_name"
  exit 1
fi

echo "🔧 rename 설치"
flutter pub add rename

echo "✏️ 앱 이름 변경"
dart run rename setAppName --value "$APP_NAME"

echo "✏️ 번들 ID 변경"
dart run rename setBundleId --value "$BUNDLE_ID"

echo "✏️ pubspec name 변경"
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/^name:.*/name: $PROJECT_NAME/" pubspec.yaml
else
  sed -i "s/^name:.*/name: $PROJECT_NAME/" pubspec.yaml
fi

echo "📁 Android 패키지 구조 변경 시작..."

MAIN_ACTIVITY=$(find android/app/src/main/kotlin -type f -name "MainActivity.kt" -print -quit || true)
if [ -z "$MAIN_ACTIVITY" ]; then
  echo "❌ MainActivity.kt를 찾지 못했습니다. android/app/src/main/kotlin 아래 구조를 확인해주세요."
  exit 1
fi

OLD_DIR=$(dirname "$MAIN_ACTIVITY")
OLD_ROOT="${OLD_DIR%/*}" # 예: .../kotlin/com/soogil/old -> .../kotlin/com/soogil

IFS='.' read -ra NEW <<< "$BUNDLE_ID"
NEW_PATH="android/app/src/main/kotlin"
for part in "${NEW[@]}"; do
  NEW_PATH="$NEW_PATH/$part"
done

echo "📁 기존 패키지 폴더(파일이 있는 위치): $OLD_DIR"
echo "📁 새로운 패키지 폴더: $NEW_PATH"

mkdir -p "$NEW_PATH"
mv "$OLD_DIR"/* "$NEW_PATH" || true

echo "🖋 Kotlin package 선언 변경"
find android/app/src/main/kotlin -type f -name "*.kt" -exec \
  sed -i ${OSTYPE/darwin/''} "s/^package .*/package $BUNDLE_ID/" {} \; 2>/dev/null || true

echo "🧹 flutter clean + pub get"
flutter clean
flutter pub get

echo "🎉 전체 초기 세팅 완료!"
