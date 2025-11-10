#!/bin/bash
set -e
echo "Creating flutter project 'financeapp' with org ac.id ..."
if ! command -v flutter >/dev/null 2>&1; then
  echo "Error: flutter not found. Install Flutter and ensure it's on PATH."
  exit 1
fi
if [ -d "financeapp" ]; then
  echo "Directory 'financeapp' exists. Remove it or run this script in a different folder."
  exit 1
fi
flutter create --org ac.id financeapp
cp -r lib financeapp/
cp pubspec.yaml financeapp/
cp -r assets financeapp/
echo "Project created. Run:"
echo "  cd financeapp"
echo "  flutter pub get"
echo "  flutter run"
