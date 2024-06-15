[![Test](https://github.com/ciriti/ZTC/actions/workflows/ci.yml/badge.svg)](https://github.com/ciriti/ZTC/actions/workflows/ci.yml)
[![Test](https://github.com/ciriti/ZTC/actions/workflows/ci.yml/badge.svg)](https://github.com/ciriti/ZTC/actions/workflows/ci-it.yml)


# ZT Client

## Introduction

ZT Client is a simplified GUI application that represents a VPN app. The app interacts with a mock registration API and a provided mock networking daemon/service to manage the connections. The application demonstrates how to establish a connection, disconnect, and check the status of the VPN connection.

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

The application is designed following the principles of Clean Architecture and SOLID principles to ensure maintainability, scalability, and testability.

### Layers

1. **Presentation Layer**: Handles the UI of the application.
2. **Application Layer**: Contains the business logic of the application.
3. **Domain Layer**: Defines the core entities and use cases.
4. **Data Layer**: Manages data operations, including network requests and local storage.

Note: The files with `.freezed.dart` and `.g.dart` extensions are generated files and can be ignored.

Directory structure:
```
.
├── main.dart
└── src
    ├── application
    │   └── services
    │       ├── auth_service.dart
    │       ├── auth_service_provider.dart
    │       ├── connection_service_notifier.dart
    │       ├── timer_manager.dart
    │       └── timer_manager_provider.dart
    ├── data
    │   ├── auth_token_data_store.dart
    │   ├── auth_token_data_store_provider.dart
    │   ├── bytes_converter.dart
    │   ├── bytes_converter_provider.dart
    │   ├── log_data_store.dart
    │   ├── log_data_store_provider.dart
    │   ├── socket_data_store.dart
    │   └── socket_data_store_provider.dart
    ├── domain
    │   └── models
    │       ├── auth_token.dart
    │       ├── socket_response.dart
    │       └── socket_state.dart
    ├── exceptions
    │   ├── safe_execution.dart
    │   └── ztc_exceptions.dart
    ├── presentation
    │   └── pages
    │       └── ztc_home_page.dart
    └── utils
        ├── app_sizes.dart
        └── ext.dart
```

### Explanation

- **Presentation Layer**: Contains the UI components.
  - `ztc_home_page.dart`: The main UI page where users interact with the application.

- **Application Layer**: Contains service classes that coordinate the business logic.
  - `auth_service.dart`: Manages authentication-related operations.
  - `auth_service_provider.dart`: Provides authentication service instance.
  - `connection_service_notifier.dart`: Manages the connection state and interacts with the data layer.
  - `timer_manager.dart`: Manages periodic tasks, such as status updates.

- **Domain Layer**: Defines the entities.
  - `auth_token.dart`: Represents the authentication token.
  - `socket_response.dart`: Represents the response from the socket.
  - `socket_state.dart`: Represents the state of the socket connection.

- **Data Layer**: Manages data sources, such as APIs and local storage.
  - `auth_token_data_store.dart`: Manages the storage of authentication tokens.
  - `bytes_converter.dart`: Handles byte conversion for socket communication.
  - `log_data_store.dart`: Manages logs for the application.
  - `socket_data_store.dart`: Manages socket connections and communication.

- **Exceptions**: Contains custom exception classes for error handling.
  - `safe_execution.dart`: Provides a safe execution wrapper to handle errors gracefully.
  - `ztc_exceptions.dart`: Defines custom exceptions for the application.

- **Utilities**: Contains utility functions and constants used throughout the application.
  - `app_sizes.dart`: Defines standard sizes for UI components.
  - `ext.dart`: Contains extension methods for various operations.

## Setup and Installation

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)

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

## Testing

To run unit tests:

```sh
flutter test
```

For integration:

```sh
flutter test ui_test
flutter run -t ui_test/ztc_home_page_test.dart  -d macos // to test in simulator
```

## Dependencies

- `dartz`: A functional programming library for Dart that provides types and functions for handling operations like Either, [link](https://pub.dev/packages/dartz).
- `dio`: An HTTP client for Dart that supports, [link](https://pub.dev/packages/dio).
- `equatable`: A Dart package that helps to implement equality without needing to override '==' and 'hashCode' manually, [link](https://pub.dev/packages/equatable).
- `flutter_riverpod`: A reactive caching and data-binding framework that simplifies the state management in Flutter applications, [link](https://pub.dev/packages/flutter_riverpod).
- `freezed_annotation`: Annotations for the Freezed package, which helps to generate data classes in Dart, [link](https://pub.dev/packages/freezed_annotation).
- `json_serializable`: A code generator for JSON serialization that generates code for encoding and decoding JSON directly from your Dart classes, [link](https://pub.dev/packages/json_serializable).
- `json_annotation`: Supports JSON serialization and deserialization in Dart. Used in conjunction with json_serializable, [link](https://pub.dev/packages/json_annotation).
- `path_provider`: A Flutter plugin for finding commonly used locations on the filesystem, such as the temp and app data directories, [link](https://pub.dev/packages/path_provider).
- `shared_preferences`: A Flutter plugin for storing simple data in a key-value format on the device, [link](https://pub.dev/packages/shared_preferences).
- `riverpod_annotation`: Annotations for Riverpod to generate providers and simplify dependency injection, [link](https://pub.dev/packages/riverpod_annotation).
- `mocktail`: A Dart package that simplifies creating mocks and stubs in tests, particularly for unit testing, [link](https://pub.dev/packages/mocktail).
- `build_runner`: A tool to generate files using Dart code generators, [link](https://pub.dev/packages/build_runner).
- `custom_lint`: A plugin to create custom lint rules for Dart and Flutter projects, [link](https://pub.dev/packages/custom_lint).
- `riverpod_generator`: A code generator for Riverpod to automate the creation of providers, [link](https://pub.dev/packages/riverpod_generator).
- `riverpod_lint`: A set of lint rules to improve the use of Riverpod in Dart and Flutter projects, [link](https://pub.dev/packages/riverpod_lint).
- `freezed`: A code generator for pattern-matching/copy in Dart, [link](https://pub.dev/packages/freezed).



## Error Handling

The application includes robust error handling mechanisms to manage various scenarios, such as network failures, invalid tokens, and daemon errors. Errors are logged and displayed to the user appropriately.