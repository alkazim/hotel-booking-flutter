# Hotel Booking App

A responsive hotel room booking application built with Flutter as part of the Raintech Software coding exercise.

## Features

- Browse available hotel rooms with room details and pricing
- Select check-in and check-out dates
- Select a room for the stay
- Calculate the number of nights automatically
- Calculate the total booking price
- Validate check-in and check-out dates
- Display clear validation and error messages
- Filter rooms based on the number of guests
- Responsive layout for desktop and mobile screens
- Booking summary showing:
  - Selected room
  - Check-in date
  - Check-out date
  - Number of nights
  - Total amount
- Unit tests for booking calculation and validation logic

## Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **Platform:** Flutter Web
- **UI:** Material Design with custom responsive components
- **Testing:** Flutter test framework

The application uses local sample data and does not require a backend or database.

## How to Run

### Prerequisites

Make sure you have the following installed:

- Flutter SDK
- Dart SDK (included with Flutter)
- Google Chrome or another supported Flutter web browser

### Install Dependencies

```bash
flutter pub get

Run the Application
flutter run -d chrome

The application will open in Google Chrome.

Run Tests
flutter test
Run Static Analysis
flutter analyze
Project Structure
lib/
├── data/          # Sample hotel room data
├── logic/         # Booking calculations and validation
├── models/        # Data models
├── widgets/       # Reusable UI components
└── main.dart      # Application entry point

test/
└── booking_calculator_test.dart
Booking Logic

The booking calculation logic is separated from the UI so that the core booking rules can be tested independently.

The application validates that:

A room is selected
Both check-in and check-out dates are selected
Check-in is not in the past
Check-out is after check-in
The number of nights is calculated correctly
The total price is calculated correctly based on the room's nightly rate
Improvements With More Time

For a production-ready application, I would consider adding:

A backend/API for real-time room availability
Persistent booking storage
Booking conflict and date-overlap handling
Authentication and user accounts
A booking confirmation flow
More comprehensive widget and integration tests
Loading, empty, and network-error states
Improved accessibility and keyboard navigation
A more advanced date-range selection experience
