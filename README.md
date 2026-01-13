# home_repair_app

This project has been tested on Android with Flutter version 3.32.8.
The project does build on iOS as well (tested on iOS iPhone 12, iOS version 18.6.2), but the screenshots are not rendered, so use Android to get the
full experience.

The project is built using https://pub.dev/packages/ar_flutter_plugin_2 which is in turn a adaptation of  https://github.com/SceneView/sceneview-android

The initial idea was to build it as a native Android project using Jetpack Compose, but due to time constraints and quite a bit of trouble
getting things to work some things were simplified and abstracted away.

The initial idea was to try to record the session from SceneView, but after many tries this failed, so a simpler solution was adapted, where interest
points from the sceneview could be marked and screenshots would be taken of these interest points. Afterwards the user has the option to add comments
to clarify the images taken. At the moment there is no caching so the data only lives until the current app session is live.

A wiser man would have taken the easier road and tried to implement this using RoomPlan SDK on iOS, alas I am not a wise man.

## How to run me:

Install Flutter and Android studio.

To make sure everything is installed nicely run:

flutter doctor -v

If all ok run to run the necessary code generation
dart run build_runner watch -d

If you have a phone connected to the computer (developer mode ON!) run:

flutter run

Enjoy!


Links:

https://docs.flutter.dev/get-started/quick
https://docs.flutter.dev/platform-integration/android/setup