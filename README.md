# Evangélikus Énekeskönyv

Flutter port of the Android hymnal, targeting Android and iOS. The original Hungarian song, liturgy, prayer, and settings JSON files and score scans are kept as bundled assets.

## Run

Install the Flutter SDK, then from this directory run:

```sh
flutter pub get
flutter run
```

The Android and iOS runner projects are included. iOS builds require macOS and Xcode; Android builds require the Android SDK.

## Source layout

- `lib/main.dart` loads the catalog and preferences, then starts the app.
- `lib/app/` contains app state and light/dark themes.
- `lib/navigation/app_routes.dart` owns named routes: `/settings` and `/entry/<id>`.
- `lib/screens/` contains the home, search, contents, daily songs, detail, and settings screens.
- `lib/widgets/` contains reusable list rows, score images, and liturgy text.
- `lib/catalog.dart` loads and searches the bundled JSON collections.


## Download

You can dowload the app by coping this repo and bulid it on your computer 
or from this drive (if there is a more official way in github please let me know, I'm new to Git):
https://drive.google.com/file/d/1AD5_Njmc-rh8brmMGaK8ZFINjChwfSBI/view?usp=sharing

Hopefully, soon this will be avalible in Google Play Sotre and in Apple Store too!