import 'package:flutter_test/flutter_test.dart';

import 'package:hotel_booking_flutter/main.dart';

void main() {
  testWidgets('Hotel booking screen shows room list', (tester) async {
    await tester.pumpWidget(const HotelBookingApp());

    expect(find.text('Hotel Booking'), findsOneWidget);
    expect(find.text('Room Selection'), findsOneWidget);
    expect(find.text('Room R101'), findsOneWidget);
    expect(find.text('Room R301'), findsOneWidget);
    expect(find.text('\u20B93500 / night'), findsWidgets);
    expect(find.text('Deluxe Room'), findsNWidgets(2));
    expect(find.text('Selected Room'), findsNothing);
  });

  testWidgets('Selecting a room shows the summary', (tester) async {
    await tester.pumpWidget(const HotelBookingApp());

    await tester.tap(find.text('Room R101'));
    await tester.pumpAndSettle();

    expect(find.text('Selected Room'), findsOneWidget);
    expect(find.text('R101'), findsOneWidget);
  });
}
