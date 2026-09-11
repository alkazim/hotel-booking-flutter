import 'package:flutter_test/flutter_test.dart';

import 'package:hotel_booking_flutter/logic/booking_calculator.dart';
import 'package:hotel_booking_flutter/models/room.dart';

void main() {
  const room = Room(
    roomCode: 'R101',
    roomType: 'Deluxe Room',
    pricePerNight: 3500,
    maxGuests: 2,
  );

  final checkIn = DateTime(2026, 9, 15);
  final checkOut = DateTime(2026, 9, 18);

  group('calculateBooking', () {
    test('calculates a valid multi-night booking', () {
      final result = calculateBooking(
        checkIn: checkIn,
        checkOut: checkOut,
        room: room,
      );

      expect(result.errorMessage, isNull);
      expect(result.nights, 3);
      expect(result.total, 10500);
    });

    test('calculates a one-night stay', () {
      final result = calculateBooking(
        checkIn: checkIn,
        checkOut: DateTime(2026, 9, 16),
        room: room,
      );

      expect(result.errorMessage, isNull);
      expect(result.nights, 1);
      expect(result.total, 3500);
    });

    test('rejects a same-day check-in and check-out', () {
      final result = calculateBooking(
        checkIn: checkIn,
        checkOut: DateTime(2026, 9, 15),
        room: room,
      );

      expect(result.errorMessage, 'Check-out must be after check-in.');
      expect(result.nights, 0);
      expect(result.total, 0);
    });

    test('rejects a check-out before check-in', () {
      final result = calculateBooking(
        checkIn: DateTime(2026, 9, 18),
        checkOut: DateTime(2026, 9, 15),
        room: room,
      );

      expect(result.errorMessage, 'Check-out must be after check-in.');
      expect(result.nights, 0);
      expect(result.total, 0);
    });

    test('rejects a check-in date in the past', () {
      final result = calculateBooking(
        checkIn: DateTime(2020, 1, 1),
        checkOut: DateTime(2020, 1, 3),
        room: room,
      );

      expect(result.errorMessage, 'Check-in date cannot be in the past.');
      expect(result.nights, 0);
      expect(result.total, 0);
    });

    test('returns error when no room is selected', () {
      final result = calculateBooking(
        checkIn: checkIn,
        checkOut: checkOut,
        room: null,
      );

      expect(result.errorMessage, 'Please select a room.');
      expect(result.nights, 0);
      expect(result.total, 0);
    });

    test('returns error when both dates are missing', () {
      final result = calculateBooking(
        checkIn: null,
        checkOut: null,
        room: room,
      );

      expect(result.errorMessage, 'Please select both dates.');
      expect(result.nights, 0);
      expect(result.total, 0);
    });

    test('returns error when check-out date is missing', () {
      final result = calculateBooking(
        checkIn: checkIn,
        checkOut: null,
        room: room,
      );

      expect(result.errorMessage, 'Please select both dates.');
      expect(result.nights, 0);
      expect(result.total, 0);
    });
  });
}