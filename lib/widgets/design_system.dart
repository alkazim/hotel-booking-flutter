import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────
// Premium hotel palette: midnight navy + champagne
// ──────────────────────────────────────────────────────

const kNavyDeep = Color(0xFF090E1A);
const kNavy = Color(0xFF15213B);
const kNavyMuted = Color(0xFF243352);
const kIvory = Color(0xFFF5EFE3);
const kChampagne = Color(0xFFD8BE8B);
const kChampagneBright = Color(0xFFEBDBAF);
const kSuccess = Color(0xFF86D0A4);
const kError = Color(0xFFE58A8A);

const kTextPrimary = Color(0xFFF5EFE3);
const kTextSecondary = Color(0xFFADB6C6);
const kTextFaint = Color(0xFF7E8A9E);

TextStyle kKickerStyle(Color color) => TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.6,
  color: color,
);

TextStyle kTitleStyle({double fontSize = 27}) => TextStyle(
  fontSize: fontSize,
  fontWeight: FontWeight.w700,
  height: 1.15,
  color: kTextPrimary,
  letterSpacing: 0.2,
);

TextStyle kSubtitleStyle({double fontSize = 14}) => TextStyle(
  fontSize: fontSize,
  fontWeight: FontWeight.w400,
  color: kTextSecondary,
  height: 1.45,
);

// ──────────────────────────────────────────────────────
// Formatters
// ──────────────────────────────────────────────────────

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String formatCurrency(double amount) {
  final digits = amount.truncate().toString();
  final length = digits.length;
  if (length <= 3) return '\u20B9$digits';
  final lastThree = digits.substring(length - 3);
  var remaining = digits.substring(0, length - 3);
  final parts = <String>[];
  while (remaining.length > 2) {
    parts.insert(0, remaining.substring(remaining.length - 2));
    remaining = remaining.substring(0, remaining.length - 2);
  }
  parts.insert(0, remaining);
  return '\u20B9${parts.join(',')},$lastThree';
}

// ──────────────────────────────────────────────────────
// Small decorative primitives
// ──────────────────────────────────────────────────────

class GoldBar extends StatelessWidget {
  const GoldBar({super.key, this.width = 22, this.height = 2});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kChampagne, kChampagneBright]),
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(color: kChampagne.withValues(alpha: 0.45), blurRadius: 6),
        ],
      ),
    );
  }
}

class AccentDot extends StatelessWidget {
  const AccentDot({super.key, this.color = kSuccess, this.size = 7});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 5),
        ],
      ),
    );
  }
}
