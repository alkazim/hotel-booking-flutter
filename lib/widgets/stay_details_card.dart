import 'package:flutter/material.dart';

import 'design_system.dart';
import 'glass_panel.dart';

/// Premium glass "Stay Details" panel with date controls.
class StayDetailsCard extends StatelessWidget {
  const StayDetailsCard({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.onCheckInTap,
    required this.onCheckOutTap,
    this.compact = false,
  });

  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final VoidCallback onCheckInTap;
  final VoidCallback onCheckOutTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 20,
      blur: 15,
      padding: EdgeInsets.all(compact ? 18 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const GoldBar(),
              const SizedBox(width: 10),
              Text('STAY DETAILS', style: kKickerStyle(kTextSecondary)),
            ],
          ),
          SizedBox(height: compact ? 4 : 6),
          Text(
            'Choose your dates',
            style: kSubtitleStyle(fontSize: compact ? 13 : 14),
          ),
          SizedBox(height: compact ? 14 : 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final checkIn = _DateSelector(
                label: 'CHECK-IN',
                sublabel: 'Select arrival date',
                date: checkInDate,
                onTap: onCheckInTap,
                compact: compact,
              );
              final checkOut = _DateSelector(
                label: 'CHECK-OUT',
                sublabel: 'Select departure date',
                date: checkOutDate,
                onTap: onCheckOutTap,
                compact: compact,
              );
              if (constraints.maxWidth < 420) {
                return Column(
                  children: [
                    checkIn,
                    SizedBox(height: compact ? 10 : 12),
                    checkOut,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: checkIn),
                  SizedBox(width: compact ? 12 : 16),
                  Expanded(child: checkOut),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DateSelector extends StatefulWidget {
  const _DateSelector({
    required this.label,
    required this.sublabel,
    required this.date,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final String sublabel;
  final DateTime? date;
  final VoidCallback onTap;
  final bool compact;

  @override
  State<_DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<_DateSelector> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hasDate = widget.date != null;

    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(widget.compact ? 12 : 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: hasDate
                  ? kNavy.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: _hovered ? 0.09 : 0.05),
              border: Border.all(
                color: hasDate
                    ? kChampagne.withValues(alpha: 0.45)
                    : Colors.white.withValues(alpha: _hovered ? 0.3 : 0.14),
              ),
              boxShadow: [
                if (_hovered)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: hasDate
                      ? kChampagne
                      : Colors.white.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      SizedBox(height: widget.compact ? 3 : 5),
                      Text(
                        hasDate ? formatDate(widget.date!) : 'Select date',
                        style: TextStyle(
                          fontSize: widget.compact ? 14 : 15,
                          fontWeight: hasDate
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: hasDate ? kTextPrimary : kTextFaint,
                        ),
                      ),
                      if (!hasDate) ...[
                        SizedBox(height: widget.compact ? 2 : 3),
                        Text(
                          widget.sublabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
