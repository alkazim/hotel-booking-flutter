import 'package:flutter_test/flutter_test.dart';

import 'package:hotel_booking_flutter/logic/booking_calculator.dart';
import 'package:hotel_booking_flutter/models/room.dart';

const _deluxeRoom = Room(
  roomCode: 'R101',
  roomType: 'Deluxe Room',
  pricePerNight: 3500,
  maxGuests: 2,
);

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final todayPlus1 = today.add(const Duration(days: 1));
  final todayPlus3 = today.add(const Duration(days: 3));

  group('calculateBooking', () {
    test('returns error when no room is selected', () {
      final result = calculateBooking(
        room: null,
        checkIn: today,
        checkOut: todayPlus1,
      );

      expect(result.errorMessage, 'Please select a room.');
    });

    test('returns error when check-in is missing', () {
      final result = calculateBooking(
        room: _deluxeRoom,
        checkIn: null,
        checkOut: todayPlus1,
      );

      expect(result.errorMessage, 'Please select both dates.');
    });

    test('returns error when check-out is missing', () {
      final result = calculateBooking(
        room: _deluxeRoom,
        checkIn: today,
        checkOut: null,
      );

      expect(result.errorMessage, 'Please select both dates.');
    });

    test('rejects a check-in date in the past', () {
      final result = calculateBooking(
        room: _deluxeRoom,
        checkIn: today.subtract(const Duration(days: 1)),
        checkOut: todayPlus1,
      );

      expect(result.errorMessage, 'Check-in date cannot be in the past.');
    });

    test('rejects check-out on the same date as check-in', () {
      final result = calculateBooking(
        room: _deluxeRoom,
        checkIn: today,
        checkOut: today,
      );

      expect(result.errorMessage, 'Check-out must be after check-in.');
    });

    test('rejects check-out before check-in', () {
      final result = calculateBooking(
        room: _deluxeRoom,
        checkIn: todayPlus3,
        checkOut: todayPlus1,
      );

      expect(result.errorMessage, 'Check-out must be after check-in.');
    });

    test('calculates nights and total for a valid booking', () {
      final result = calculateBooking(
        room: _deluxeRoom,
        checkIn: today,
        checkOut: todayPlus3,
      );

      expect(result.errorMessage, isNull);
      expect(result.nights, 3);
      expect(result.total, 10500);
    });

    test('calculates a one-night stay', () {
      final result = calculateBooking(
        room: _deluxeRoom,
        checkIn: today,
        checkOut: todayPlus1,
      );

      expect(result.errorMessage, isNull);
      expect(result.nights, 1);
      expect(result.total, 3500);
    });
  });
}
