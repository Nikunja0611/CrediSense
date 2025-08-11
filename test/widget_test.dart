import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:credisense/app.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our CredisenseApp and trigger a frame.
    await tester.pumpWidget(const CredisenseApp());

    // Check for a widget that should be on the first screen (Login page title)
    expect(find.text('Sign in'), findsOneWidget);
  });
}
