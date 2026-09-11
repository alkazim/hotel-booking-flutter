import 'package:flutter/material.dart';
import 'package:hotel_booking_flutter/data/sample_rooms.dart';
import 'package:hotel_booking_flutter/logic/booking_calculator.dart';
import 'package:hotel_booking_flutter/models/room.dart';
import 'package:hotel_booking_flutter/widgets/booking_header.dart';
import 'package:hotel_booking_flutter/widgets/booking_summary.dart';
import 'package:hotel_booking_flutter/widgets/design_system.dart';
import 'package:hotel_booking_flutter/widgets/room_card.dart';
import 'package:hotel_booking_flutter/widgets/stay_details_card.dart';

void main() => runApp(const HotelBookingApp());

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kNavy,
          primary: kNavy,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: kNavyDeep,
        useMaterial3: true,
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          headerBackgroundColor: kNavy,
          headerForegroundColor: Colors.white,
          headerHeadlineStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          headerHelpStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
          weekdayStyle: const TextStyle(
            color: Color(0xFF6B7486),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          dayStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          todayBorder: const BorderSide(color: kNavy, width: 1.5),
          todayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return kNavy;
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return kNavy;
            return Colors.transparent;
          }),
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFB9BFCC);
            }
            return kNavy;
          }),
          cancelButtonStyle: TextButton.styleFrom(
            foregroundColor: kNavy,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          confirmButtonStyle: TextButton.styleFrom(
            foregroundColor: kNavy,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const HotelBookingScreen(),
    );
  }
}

// ──────────────────────────────────────────────────────
// Screen
// ──────────────────────────────────────────────────────

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({super.key});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen>
    with TickerProviderStateMixin {
  Room? selectedRoom;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  late final AnimationController _pageAnim;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _lastDate => _today.add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    _pageAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _pageAnim.dispose();
    super.dispose();
  }

  Future<void> _pickCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: checkInDate ?? _today,
      firstDate: _today,
      lastDate: _lastDate,
    );
    if (picked == null) return;
    setState(() {
      checkInDate = picked;
      if (checkOutDate != null && !checkOutDate!.isAfter(picked)) {
        checkOutDate = null;
      }
    });
  }

  Future<void> _pickCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate ?? checkInDate ?? _today,
      firstDate: checkInDate ?? _today,
      lastDate: _lastDate,
    );
    if (picked == null) return;
    setState(() => checkOutDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final result = calculateBooking(
      checkIn: checkInDate,
      checkOut: checkOutDate,
      room: selectedRoom,
    );

    final isEmpty =
        selectedRoom == null && checkInDate == null && checkOutDate == null;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _AtmosphereBackground()),
          Column(
            children: [
              const BookingHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    final isTablet = constraints.maxWidth > 640;
                    final summaryWidth = constraints.maxWidth > 1100
                        ? 340.0
                        : 300.0;

                    final mainContent = _buildMainContent(
                      compact: isWide || isTablet,
                    );
                    final summaryPanel = BookingSummaryPanel(
                      result: result,
                      room: selectedRoom,
                      checkIn: checkInDate,
                      checkOut: checkOutDate,
                      isEmpty: isEmpty,
                    );

                    if (isWide || isTablet) {
                      final gap = isWide ? 28.0 : 20.0;
                      final pad = isWide ? 32.0 : 20.0;

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1180),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(pad, 28, pad, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRect(
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.only(bottom: pad),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _animate(
                                            begin: 0.0,
                                            end: 0.4,
                                            child: const _HeroSection(),
                                          ),
                                          SizedBox(height: gap),
                                          mainContent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: gap),
                                SizedBox(
                                  width: summaryWidth,
                                  child: SingleChildScrollView(
                                    child: _animate(
                                      begin: 0.25,
                                      end: 0.9,
                                      child: summaryPanel,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _animate(
                            begin: 0.0,
                            end: 0.4,
                            child: const _HeroSection(),
                          ),
                          const SizedBox(height: 22),
                          mainContent,
                          const SizedBox(height: 22),
                          summaryPanel,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent({required bool compact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _animate(
          begin: 0.08,
          end: 0.5,
          child: StayDetailsCard(
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            onCheckInTap: _pickCheckInDate,
            onCheckOutTap: _pickCheckOutDate,
            compact: compact,
          ),
        ),
        SizedBox(height: compact ? 20 : 32),
        _animate(
          begin: 0.15,
          end: 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const GoldBar(),
                  const SizedBox(width: 10),
                  Text('AVAILABLE ROOMS', style: kKickerStyle(kTextSecondary)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Select one room for your stay',
                style: kSubtitleStyle(fontSize: 14),
              ),
              SizedBox(height: compact ? 12 : 16),
              RoomList(
                rooms: sampleRooms,
                selectedRoom: selectedRoom,
                compact: compact,
                onRoomSelected: (room) {
                  setState(() => selectedRoom = room);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _animate({
    required double begin,
    required double end,
    required Widget child,
  }) {
    final fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _pageAnim,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ),
    );
    final slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _pageAnim,
            curve: Interval(begin, end, curve: Curves.easeOut),
          ),
        );
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

// ──────────────────────────────────────────────────────
// Atmosphere background
// ──────────────────────────────────────────────────────

class _AtmosphereBackground extends StatelessWidget {
  const _AtmosphereBackground();

  static const String _bgUrl =
      'https://images.unsplash.com/photo-1564501049412-61c2a3793081?w=1800&q=80&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF131D32), kNavyDeep],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _bgUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(color: const Color(0xFF0F1728));
            },
          ),
          // Readability overlay (keeps photograph recognizable).
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kNavyDeep.withValues(alpha: 0.68),
                  kNavyDeep.withValues(alpha: 0.4),
                  kNavyDeep.withValues(alpha: 0.86),
                ],
              ),
            ),
          ),
          // Soft vignette for depth.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.2, -0.2),
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
                stops: const [0.55, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// Hero
// ──────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const GoldBar(width: 26),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'RAINTECH HOTEL \u2022 ROOM RESERVATIONS',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: kChampagne.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Find your perfect stay', style: kTitleStyle()),
        const SizedBox(height: 8),
        Text(
          'Thoughtfully designed rooms for a comfortable stay.',
          style: kSubtitleStyle(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const AccentDot(),
            const SizedBox(width: 8),
            Text(
              'Rooms available for your dates',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
