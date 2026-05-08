@echo off
echo Deleting conflicting Groovy files...
del android\build.gradle
del android\settings.gradle
del android\app\build.gradle
echo Done! Please run 'flutter run' now.
pause
