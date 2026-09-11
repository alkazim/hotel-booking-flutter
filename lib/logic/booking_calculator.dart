import 'package:hotel_booking_flutter/models/room.dart';

/// The result of validating and calculating a booking.
///
/// When [errorMessage] is non-null the booking is invalid and [nights] and
/// [total] should be ignored. When [errorMessage] is null the booking is valid.
class BookingResult {
  final int nights;
  final double total;
  final String? errorMessage;

  const BookingResult({
    required this.nights,
    required this.total,
    required this.errorMessage,
  });
}

/// Validates a booking and calculates its cost.
///
/// Returns an invalid [BookingResult] with a descriptive [BookingResult.errorMessage]
/// when required data is missing or the stay dates are invalid. Otherwise returns
/// a valid result with the number of nights and the total price
/// (nights x pricePerNight).
BookingResult calculateBooking({
  required DateTime? checkIn,
  required DateTime? checkOut,
  required Room? room,
}) {
  if (room == null) {
    return const BookingResult(
      nights: 0,
      total: 0,
      errorMessage: 'Please select a room.',
    );
  }

  if (checkIn == null || checkOut == null) {
    return const BookingResult(
      nights: 0,
      total: 0,
      errorMessage: 'Please select both dates.',
    );
  }

  final today = _dateOnly(DateTime.now());
  final normalizedCheckIn = _dateOnly(checkIn);

  if (normalizedCheckIn.isBefore(today)) {
    return const BookingResult(
      nights: 0,
      total: 0,
      errorMessage: 'Check-in date cannot be in the past.',
    );
  }

  final normalizedCheckOut = _dateOnly(checkOut);

  if (!normalizedCheckOut.isAfter(normalizedCheckIn)) {
    return const BookingResult(
      nights: 0,
      total: 0,
      errorMessage: 'Check-out must be after check-in.',
    );
  }

  final nights = normalizedCheckOut.difference(normalizedCheckIn).inDays;
  final total = nights * room.pricePerNight;

  return BookingResult(nights: nights, total: total, errorMessage: null);
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
