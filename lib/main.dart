import 'package:flutter/material.dart';
import 'package:hotel_booking_flutter/data/sample_rooms.dart';
import 'package:hotel_booking_flutter/models/room.dart';
import 'package:hotel_booking_flutter/widgets/room_list.dart';

void main() {
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A2744),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        useMaterial3: true,
      ),
      home: const HotelBookingScreen(),
    );
  }
}

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({super.key});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  Room? selectedRoom;

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1A2744);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Hotel Booking',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Selection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select a room for your stay',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 28),
                  RoomList(
                    rooms: sampleRooms,
                    selectedRoom: selectedRoom,
                    onRoomSelected: (room) {
                      setState(() {
                        selectedRoom = room;
                      });
                    },
                  ),
                  if (selectedRoom != null) ...[
                    const SizedBox(height: 28),
                    _SelectedRoomSummary(room: selectedRoom!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedRoomSummary extends StatelessWidget {
  const _SelectedRoomSummary({required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1A2744);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navy.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Room',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            room.roomCode,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            room.roomType,
            style: const TextStyle(fontSize: 15, color: navy),
          ),
          const SizedBox(height: 4),
          Text(
            '\u20B9${room.pricePerNight.toStringAsFixed(0)} / night',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }
}
