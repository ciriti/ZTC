[![Test](https://github.com/ciriti/ZTC/actions/workflows/ci.yml/badge.svg)](https://github.com/ciriti/ZTC/actions/workflows/ci.yml)


# ZT Client

## Introduction

ZT Client is a simplified GUI application that represents a VPN app. The app interacts with a mock registration API and a provided mock networking daemon/service to manage VPN connections. The application demonstrates how to establish a connection, disconnect, and check the status of the VPN connection.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Setup and Installation](#setup-and-installation)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [Dependencies](#dependencies)
- [Error Handling](#error-handling)

## Features

- Connect to a mock daemon after contact the registration API.
- Disconnect from the VPN.
- Display the current status of the connection.
- Periodically check the status of the daemon.
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

### Clone the Repository

```sh
git clone https://github.com/ciriti/ZTC.git
cd ZTC
```

### Install Dependencies

```sh
flutter pub get
```


### Mock Daemon - Important Note

Replace the original path:

```python
SOCKET_PATH = "/tmp/daemon-lite"
```

with the one printed during initialization:

```dart
// lib/main.dart:10
var tempDir = await getTemporaryDirectory();
print('Please use this directory for the daemon-lite[$tempDir]');
```

and then run it.


## Running the Application

Ensure the daemon is running, then start the Flutter application.

```sh
flutter run -d macos
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

For integration:

```sh
flutter test ui_test
```

## Dependencies

- `dartz`: A functional programming library for Dart that provides types and functions for handling operations like Either, [link](https://pub.dev/packages/dartz).
- `dio`: An HTTP client for Dart that supports.
- `equatable`: A Dart package that helps to implement equality without needing to override '==' and 'hashCode' manually.
- `flutter_riverpod`: .
- `freezed_annotation`: Annotations for the Freezed package, which helps to generate data classes in Dart.
- `json_serializable`: A code generator for JSON serialization that generates code for encoding and decoding JSON directly from your Dart classes.
- `json_annotation`: Supports JSON serialization and deserialization in Dart. Used in conjunction with json_serializable.
- `path_provider`: A Flutter plugin for finding commonly used locations on the filesystem, such as the temp and app data directories.
- `shared_preferences`: A Flutter plugin for storing simple data in a key-value format on the device.
- `riverpod_annotation`: Annotations for Riverpod to generate providers and simplify dependency injection.
- `mocktail`: A Dart package that simplifies creating mocks and stubs in tests, particularly for unit testing.
- `build_runner`: A tool to generate files using Dart code generators.
- `custom_lint`: A plugin to create custom lint rules for Dart and Flutter projects.
- `riverpod_generator`: A code generator for Riverpod to automate the creation of providers.
- `riverpod_lint`: A set of lint rules to improve the use of Riverpod in Dart and Flutter projects.
- `freezed`: A code generator for pattern-matching/copy in Dart.

## Error Handling

The application includes robust error handling mechanisms to manage various scenarios, such as network failures, invalid tokens, and daemon errors. Errors are logged and displayed to the user appropriately.