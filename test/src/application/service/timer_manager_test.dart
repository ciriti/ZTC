import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ztc/src/application/services/timer_manager.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  late TimerManager timerManager;
  late MockCallback mockCallback;

  setUp(() {
    mockCallback = MockCallback();
    timerManager = TimerManager(duration: 1);
  });

  test('startLogging should call the callback periodically', () async {
    // Arrange
    when(() => mockCallback.call()).thenAnswer((_) {});

    // Act
    timerManager.startLogging(mockCallback.call);
    await Future.delayed(const Duration(seconds: 3));

    // Assert
    verify(() => mockCallback.call()).called(greaterThanOrEqualTo(2));

    timerManager.stopLogging();
  });
}
