import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:logitms/main.dart';

void main() {
  testWidgets('App launches and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LogiTMSApp());

    // Verify that login screen is displayed
    expect(find.text('LogiTMS'), findsOneWidget);
    expect(find.text('Giris Yap'), findsOneWidget);
  });
}
