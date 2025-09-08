# Flutter API Configuration Fix for Android Emulator

This directory contains the Flutter frontend application with a fix for Android emulator connectivity issues.

## Problem Solved

The Android emulator cannot access `127.0.0.1` (localhost) because it refers to the emulator itself, not the host machine. This caused connection errors when trying to reach the Django backend API.

## Solution

The `ApiService` class in `lib/services/api_service.dart` now includes platform-aware URL detection:

- **Android Emulator**: `http://10.0.2.2:8000/api` (special IP to access host machine)
- **Web Platform**: `http://127.0.0.1:8000/api` (localhost works fine)
- **iOS Simulator**: `http://127.0.0.1:8000/api` (localhost works fine)
- **Other Platforms**: `http://127.0.0.1:8000/api` (default fallback)

## Files Created

- `lib/main.dart` - Basic Flutter app that displays the current API URL
- `lib/services/api_service.dart` - Main API service with platform detection
- `test/api_service_test.dart` - Unit tests for the API service

## Usage

```dart
import 'services/api_service.dart';

// The service automatically uses the correct URL for the current platform
final response = await ApiService.login(username, password);
```

## Testing

To run tests (when Flutter is available):

```bash
flutter test
```

## Architecture

The solution uses Flutter's `Platform` class and `kIsWeb` constant to detect the current platform and return the appropriate base URL. This ensures the app works seamlessly across all platforms without manual configuration.