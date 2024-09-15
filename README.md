# Chatme

Chatme is a cross-platform messaging application developed by Ramith K S using Flutter. It supports iOS, Android, and Web platforms, offering a seamless chat experience with features like user authentication, real-time messaging, and location services.

## Features

- User authentication (login and registration)
- Real-time text messaging between users
- Persistent data storage using SQLite
- Multi-language support (English and Arabic)
- Google Maps integration with user location tracking
- Responsive UI design

## Project Structure

The project follows the MVC (Model-View-Controller) architecture:

```
lib/
├── model/
├── view/
├── controller/
├── binding/
├── service/
├── translations/
├── main.dart
└── routes.dart
```

## Dependencies

- cloud_firestore: ^5.4.1
- cupertino_icons: ^1.0.8
- firebase_auth: ^5.2.1
- firebase_core: ^3.4.1
- firebase_database: ^11.1.2
- firebase_storage: ^12.3.0
- flutter: sdk
- geolocator: ^13.0.1
- get: ^4.6.6
- google_maps_flutter: ^2.9.0
- http: ^1.2.2
- path: ^1.9.0
- sqflite: ^2.3.3+1

## Setup and Installation

1. Clone the repository
2. Ensure you have Flutter installed and set up
3. Run `flutter pub get` to install dependencies
4. Configure Firebase for your project
5. Run the app using `flutter run`

## Platform Support

- Android
- iOS
- Web

## Known Issues and Future Improvements

- QR code scanner for device token sharing is not implemented
- Firebase Cloud Messaging for push notifications is not fully implemented, but OneSignal push notifications are available as an alternative

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check issues page if you want to contribute.

## Author

Ramith K S

## License

This project is licensed under the MIT License.
