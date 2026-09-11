import 'dart:ui';

import 'package:flutter/material.dart';

import 'design_system.dart';

/// Floating glass navigation bar pinned above the workspace.
class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 640;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          color: kNavyDeep.withValues(alpha: 0.55),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
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
                child: Icon(
                  Icons.apartment_rounded,
                  size: 20,
                  color: kChampagneBright,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'RAINTECH',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              if (!isNarrow) ...[
                const SizedBox(width: 6),
                Text(
                  'HOTEL',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
              const Spacer(),
              Text(
                'Hotel Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isNarrow ? 15 : 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
              const Spacer(),
              if (!isNarrow) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: kChampagne.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AccentDot(color: kSuccess, size: 6),
                      const SizedBox(width: 6),
                      Text(
                        'Booking Desk',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white.withValues(alpha: 0.85),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
