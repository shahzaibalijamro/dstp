import 'package:flutter_test/flutter_test.dart';
import 'package:prayer_time/main.dart';

void main() {
  testWidgets('shows the city and all daily prayer times', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PrayerTimeApp());

    expect(find.text('Prayer Time'), findsOneWidget);
    expect(find.text('Karachi'), findsOneWidget);
    expect(find.text('Sun,16 Jul 2023'), findsOneWidget);

    for (final name in [
      'Fajr',
      'Sunrise',
      'Dhuhr',
      'Asr',
      'Maghrib',
      "Isha'A",
    ]) {
      expect(find.text(name), findsOneWidget);
    }

    for (final time in [
      '04:25',
      '05:51',
      '12:38',
      '16:02',
      '19:25',
      '20:50',
    ]) {
      expect(find.text(time), findsOneWidget);
    }
  });
}
