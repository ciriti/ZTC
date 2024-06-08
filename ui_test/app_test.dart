import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ztc/main.dart';

void main() {
  testWidgets('Check if status text updates correctly when buttons are pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ZTCApp());

    expect(find.text('Status: Disconnected'), findsOneWidget);
    expect(find.text('Status: Connected'), findsNothing);

    await tester.tap(find.text('Connect'));
    await tester.pump();

    expect(find.text('Status: Connected'), findsOneWidget);
    expect(find.text('Status: Disconnected'), findsNothing);

    await tester.tap(find.text('Disconnect'));
    await tester.pump();

    expect(find.text('Status: Disconnected'), findsOneWidget);
    expect(find.text('Status: Connected'), findsNothing);
  });
}
