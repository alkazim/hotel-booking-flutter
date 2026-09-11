import 'package:flutter/material.dart';

import 'package:hotel_booking_flutter/models/room.dart';

import 'design_system.dart';
import 'glass_panel.dart';

const _roomImages = {
  'Deluxe Room':
      'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=640&h=420&fit=crop',
  'Executive Suite':
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=640&h=420&fit=crop',
  'Family Room':
      'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=640&h=420&fit=crop',
};

const _roomTaglines = {
  'Deluxe Room': 'Comfortable room for a relaxing stay',
  'Executive Suite': 'Spacious suite with premium amenities',
  'Family Room': 'Ideal for families, extra space and comfort',
};

/// Room collection with staggered entrance animation.
class RoomList extends StatefulWidget {
  const RoomList({
    super.key,
    required this.rooms,
    this.selectedRoom,
    this.compact = false,
    required this.onRoomSelected,
  });

  final List<Room> rooms;
  final Room? selectedRoom;
  final bool compact;
  final ValueChanged<Room> onRoomSelected;

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.rooms.length, (index) {
        final room = widget.rooms[index];
        final isSelected = widget.selectedRoom?.roomCode == room.roomCode;
        final start = (index * 0.1).clamp(0.0, 1.0);
        final end = (start + 0.4).clamp(0.0, 1.0);

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: _anim,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _anim,
                    curve: Interval(start, end, curve: Curves.easeOut),
                  ),
                ),
            child: Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? 0 : (widget.compact ? 8 : 10),
              ),
              child: RoomCard(
                room: room,
                isSelected: isSelected,
                compact: widget.compact,
                onTap: () => widget.onRoomSelected(room),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Premium hotel room card: photo, info, price, selection indicator.
class RoomCard extends StatefulWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.isSelected,
    this.compact = false,
    required this.onTap,
  });

  final Room room;
  final bool isSelected;
  final bool compact;
  final VoidCallback onTap;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final selected = widget.isSelected;
    final compact = widget.compact;
    final imageUrl = _roomImages[room.roomType] ?? _roomImages.values.first;
    final imageWidth = compact ? 104.0 : 124.0;

    return Semantics(
      button: true,
      selected: selected,
      label: 'Select ${room.roomType} ${room.roomCode}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedSlide(
            offset: _hovered ? const Offset(0, -0.02) : Offset.zero,
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            child: GlassPanel(
              borderRadius: 18,
              blur: 13,
              opacity: selected
                  ? 0.58
                  : _hovered
                  ? 0.5
                  : 0.42,
              borderOpacity: selected
                  ? 0.6
                  : _hovered
                  ? 0.3
                  : 0.14,
              borderColor: selected ? kChampagne : Colors.white,
              glow: selected,
              shadow: selected ? 30 : 22,
              padding: EdgeInsets.all(compact ? 8 : 10),
              child: SizedBox(
                height: compact ? 98 : 128,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Room photograph ──
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: imageWidth,
                        child: AnimatedScale(
                          scale: _hovered ? 1.03 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: kNavyMuted,
                              child: Icon(
                                Icons.hotel,
                                size: compact ? 26 : 34,
                                color: kChampagne.withValues(alpha: 0.6),
                              ),
                            ),
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: kNavyDeep,
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: kChampagne.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: compact ? 12 : 14),

                    // ── Room info ──
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: compact ? 4 : 6,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.roomType,
                              style: TextStyle(
                                fontSize: compact ? 14 : 16,
                                fontWeight: FontWeight.w700,
                                color: kTextPrimary,
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(height: compact ? 2 : 3),
                            Text(
                              'Room ${room.roomCode}',
                              style: TextStyle(
                                fontSize: compact ? 12 : 13,
                                color: kTextSecondary,
                              ),
                            ),
                            SizedBox(height: compact ? 5 : 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: compact ? 13 : 14,
                                  color: kChampagne.withValues(alpha: 0.5),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Up to ${room.maxGuests} guests',
                                  style: TextStyle(
                                    fontSize: compact ? 11 : 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            if (!compact) ...[
                              const SizedBox(height: 6),
                              Text(
                                _roomTaglines[room.roomType] ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // ── Divider + price ──
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    SizedBox(width: compact ? 12 : 14),
                    SizedBox(
                      width: compact ? 112 : 118,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Semantics(
                            label: 'Price per night',
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                formatCurrency(room.pricePerNight),
                                style: TextStyle(
                                  fontSize: compact ? 17 : 19,
                                  fontWeight: FontWeight.w800,
                                  color: kChampagneBright,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '/ night',
                            style: TextStyle(
                              fontSize: compact ? 11 : 12,
                              color: Colors.white.withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: selected
                                ? Column(
                                    key: const ValueKey('selected'),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: kChampagne,
                                        size: compact ? 20 : 24,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'SELECTED',
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.1,
                                          color: kChampagne,
                                        ),
                                      ),
                                    ],
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    key: const ValueKey('unselected'),
                                    color: Colors.white.withValues(alpha: 0.2),
                                    size: compact ? 20 : 24,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
