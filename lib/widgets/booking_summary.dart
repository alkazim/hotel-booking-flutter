import 'package:flutter/material.dart';

import 'package:hotel_booking_flutter/logic/booking_calculator.dart';
import 'package:hotel_booking_flutter/models/room.dart';

import 'design_system.dart';
import 'glass_panel.dart';

/// Premium glass reservation receipt that stays visible while rooms scroll.
class BookingSummaryPanel extends StatelessWidget {
  const BookingSummaryPanel({
    super.key,
    required this.result,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.isEmpty,
  });

  final BookingResult result;
  final Room? room;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final bool isEmpty;

  bool get _hasError => result.errorMessage != null;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 24,
      blur: 18,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kNavyMuted, kNavy],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kChampagne.withValues(alpha: 0.4)),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: kChampagneBright,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'YOUR BOOKING',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    color: kTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Flexible(
                child: _StatusPill(isEmpty: isEmpty, hasError: _hasError),
              ),
              const Spacer(),
              Text(
                'STATUS',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isEmpty
                ? _buildEmptyState()
                : _hasError
                ? _buildErrorState()
                : _buildValidState(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      key: const ValueKey('empty'),
      children: [
        const SizedBox(height: 8),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            shape: BoxShape.circle,
            border: Border.all(color: kChampagne.withValues(alpha: 0.18)),
          ),
          child: Icon(
            Icons.king_bed_outlined,
            size: 26,
            color: kChampagne.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Complete your stay details',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Select dates and a room to see your booking summary.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      key: ValueKey(result.errorMessage),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kError.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kError.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: kError),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              result.errorMessage!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidState() {
    return Column(
      key: const ValueKey('valid'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryRow(
          icon: Icons.king_bed_outlined,
          label: room!.roomType,
          sublabel: room!.roomCode,
        ),
        const SizedBox(height: 14),
        _SummaryRow(
          icon: Icons.date_range_outlined,
          label: '${formatDate(checkIn!)} \u2192 ${formatDate(checkOut!)}',
        ),
        const SizedBox(height: 14),
        _SummaryRow(
          icon: Icons.nights_stay_outlined,
          label: '${result.nights} nights',
        ),
        const SizedBox(height: 14),
        _SummaryRow(
          icon: Icons.payments_outlined,
          label:
              '${formatCurrency(room!.pricePerNight)} \u00D7 ${result.nights}',
        ),
        const SizedBox(height: 22),
        Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'TOTAL AMOUNT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: result.total),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatCurrency(value),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: kChampagneBright,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isEmpty, required this.hasError});

  final bool isEmpty;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isEmpty
          ? _pill('SELECT YOUR ROOM', Colors.white.withValues(alpha: 0.45))
          : hasError
          ? _pill('ACTION REQUIRED', kError)
          : _pill('READY TO BOOK', kSuccess),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      key: ValueKey(label),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AccentDot(color: color, size: 6),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.9,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label, this.sublabel});

  final IconData icon;
  final String label;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kChampagne.withValues(alpha: 0.75)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: kTextPrimary),
              ),
              if (sublabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  sublabel!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
