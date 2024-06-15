[![Test](https://github.com/ciriti/ZTC/actions/workflows/ci.yml/badge.svg)](https://github.com/ciriti/ZTC/actions/workflows/ci.yml)


# ZT Client

## Introduction

ZT Client is a simplified GUI application that represents a VPN app. The app interacts with a mock registration API and a provided mock networking daemon/service to manage VPN connections. The application is built using Flutter and demonstrates how to establish a connection, disconnect, and check the status of the VPN connection.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Setup and Installation](#setup-and-installation)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [Dependencies](#dependencies)
- [Error Handling](#error-handling)
- [Additional Features](#additional-features)
- [Contact](#contact)

## Features

- Connect to a VPN using a mock registration API.
- Disconnect from the VPN.
- Display the current status of the VPN connection.
- Periodically check the status of the VPN daemon.
- Cache the authentication token for up to 5 minutes.

## Architecture

The application is structured as follows:

- **Main Application**: The entry point of the application. Initializes necessary components and runs the app.
- **Pages**: Contains the main UI of the application, including the home page where users can connect/disconnect and view status.
- **Services**: Contains the logic for managing connections, fetching tokens, and interacting with the daemon.
- **Models**: Defines the data models used in the application.
- **Providers**: Uses Riverpod for state management, providing necessary dependencies throughout the app.

## Setup and Installation

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter
- Rust and Cargo: Only needed if you want to compile the daemon from the source. [Install Rust](https://www.rust-lang.org/tools/install)

### Clone the Repository

```sh
git clone https://github.com/ciriti/ZTC.git
cd ZTC
```

### Install Dependencies

```sh
flutter pub get
```

### Mock Daemon

Download the mock daemon from the provided link in the instructions. If you prefer to compile it yourself, follow the instructions below.

```sh
# Navigate to the daemon source directory
cd path/to/daemon/source
cargo build --release
# The binary will be located at target/release/daemon-lite
```

### Running the Daemon

Start the daemon before running the application. This can be done in a separate terminal window.

```sh
./path/to/daemon-lite
```

## Running the Application

Ensure the daemon is running, then start the Flutter application.

```sh
flutter run
```

During initialization, the application will print the directory to use for the daemon-lite:

```dart
var tempDir = await getTemporaryDirectory();
print('Please use this directory for the daemon-lite[$tempDir]');
```

## Testing

To run unit tests:

```sh
flutter test
```

Make sure all tests pass successfully.

## Dependencies

- `dartz`
- `dio`
- `equatable`
- `flutter`
- `flutter_riverpod`
- `freezed_annotation`
- `json_annotation`
- `path_provider`
- `shared_preferences`
- `riverpod_annotation`
- `mocktail`

Refer to `pubspec.yaml` for the complete list of dependencies and their versions.

## Error Handling

The application includes robust error handling mechanisms to manage various scenarios, such as network failures, invalid tokens, and daemon errors. Errors are logged and displayed to the user appropriately.

## Additional Features

- **Notifications**: Optionally, you can add notifications for status changes.
- **System Tray Integration**: The app can be enhanced to run in the system tray for better user experience.
- **Packaging**: Package the app for easy installation on macOS, Windows, or Linux.

## Contact

If you have any questions or issues, please reach out to your recruiter or contact the project maintainer through the provided communication channels.

