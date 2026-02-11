import 'package:flutter_test/flutter_test.dart';
import 'package:dvm_cattle_ration/main.dart';

void main() {
  testWidgets('App renders home dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const DvmRationApp());
    expect(find.text('গো-পুষ্টি'), findsOneWidget);
    expect(find.text('দুগ্ধবতী গরু'), findsOneWidget);
    expect(find.text('মাংস উৎপাদন'), findsOneWidget);
  });
}
