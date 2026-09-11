import 'package:flutter_test/flutter_test.dart';

import 'package:hotel_booking_flutter/main.dart';

void main() {
  testWidgets('Screen shows header, hero, and room list', (tester) async {
    await tester.pumpWidget(const HotelBookingApp());

    expect(find.text('RAINTECH'), findsOneWidget);
    expect(find.text('Hotel Booking'), findsOneWidget);
    expect(find.text('Find your perfect stay'), findsOneWidget);
    expect(find.text('Deluxe Room'), findsNWidgets(2));
    expect(find.text('Room R101'), findsOneWidget);
    expect(find.text('Room R301'), findsOneWidget);
    expect(find.text('COMPLETE YOUR STAY DETAILS'), findsNothing);
    expect(find.text('YOUR BOOKING'), findsOneWidget);
  });

  testWidgets('Selecting a room without dates shows validation error', (
    tester,
  ) async {
    await tester.pumpWidget(const HotelBookingApp());

    await tester.ensureVisible(find.text('Room R101'));
    await tester.pumpAndSettle();
    // Images resolve during settle and shift the scroll offset, so re-reveal.
    await tester.ensureVisible(find.text('Room R101'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Room R101'));
    await tester.pumpAndSettle();

    expect(find.text('Please select both dates.'), findsOneWidget);
  });

  testWidgets('Selecting a room and dates shows booking summary', (
    tester,
  ) async {
    await tester.pumpWidget(const HotelBookingApp());

    // Pick check-in
    await tester.tap(find.text('Select date').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Pick check-out
    await tester.tap(find.text('Select date').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('18'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Select room
    await tester.ensureVisible(find.text('Room R101'));
    await tester.pumpAndSettle();
    // Images resolve during settle and shift the scroll offset, so re-reveal.
    await tester.ensureVisible(find.text('Room R101'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Room R101'));
    await tester.pumpAndSettle();

    expect(find.text('YOUR BOOKING'), findsOneWidget);
    expect(find.text('Deluxe Room'), findsWidgets);
    expect(find.text('3 nights'), findsOneWidget);
  });
}
