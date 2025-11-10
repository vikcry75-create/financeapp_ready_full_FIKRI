\
@echo off
where flutter >nul 2>nul
if errorlevel 1 (
  echo ERROR: flutter not found. Install Flutter and add to PATH.
  pause
  exit /b 1
)
if exist financeapp (
  echo ERROR: folder 'financeapp' exists. Remove it first or run elsewhere.
  pause
  exit /b 1
)
flutter create --org ac.id financeapp
xcopy /E /I /Y lib financeapp\lib
copy /Y pubspec.yaml financeapp\pubspec.yaml
xcopy /E /I /Y assets financeapp\assets
echo Done. Then run:
echo   cd financeapp
echo   flutter pub get
echo   flutter run
pause
