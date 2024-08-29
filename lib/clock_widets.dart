import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:intl/intl.dart';
import 'package:moon_phase_plus/moon_widget.dart';
import 'dart:math' as math;

class ClockDivider extends StatelessWidget {
  const ClockDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final dividerColor = Colors.grey.shade600;
    return Divider(
      color: Colors.grey.shade600,
      height: 4,
    );
  }
}

class LeapYearIndicator extends StatelessWidget {
  const LeapYearIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    const textColor = Color.fromARGB(255, 199, 175, 154);
    DateTime now = DateTime.now();
    int currentYear = now.year;

    // Find the next leap year
    int nextLeapYear = currentYear;
    while (!isLeapYear(nextLeapYear)) {
      nextLeapYear++;
    }

    // Determine the rotation angle for the arrow
    int arrowPosition = (nextLeapYear - currentYear);
    if (arrowPosition > 3) {
      arrowPosition =
          1; // For cases where the next leap year is more than 3 years away
    } else if (arrowPosition == 0) {
      arrowPosition = 4; // Position L (current leap year)
    }

    // Calculate the rotation angle in radians (90 degrees per position)
    double rotationAngle = 0;
    switch (arrowPosition) {
      case 1:
        rotationAngle = 0; // No rotation for "1"
        break;
      case 2:
        rotationAngle = math.pi / 2; // Rotate 90 degrees for "2"
        break;
      case 3:
        rotationAngle = math.pi; // Rotate 180 degrees for "3"
        break;
      case 4:
        rotationAngle = -math.pi / 2; // Rotate -90 degrees for "L"
        break;
    }

    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // North (1)
          const Positioned(
            top: 0,
            child: Text(
              '1',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          // East (2)
          const Positioned(
            right: 0,
            child: Text(
              '2',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          // South (3)
          const Positioned(
            bottom: 0,
            child: Text(
              '3',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          // West (L)
          const Positioned(
            left: 0,
            child: Text(
              'L',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          // Arrow indicating the leap year
          Transform.rotate(
            angle: rotationAngle,
            child: const Icon(
              Icons.arrow_upward_rounded,
              size: 24,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Leap year check
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}

class CustomAnalogClock extends StatelessWidget {
  const CustomAnalogClock({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime lastFullMoon = calculateLastFullMoon(now);
    DateTime nextFullMoon = calculateNextFullMoon(now);

    const textColor = Color.fromARGB(255, 255, 194, 141);
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 70,
          child: Center(
            child: MoonWidget(
              date: DateTime.now(),
              resolution: 140,
              size: 70,
              moonColor: textColor,
              earthshineColor: Colors.blueGrey.shade700,
            ),
          ),
        ),
        const AnalogClock(
          hourHandColor: Colors.white,
          minuteHandColor: Colors.white,
          secondHandColor: textColor,
          dialColor: Colors.transparent,
          markingColor: Colors.white,
          centerPointColor: textColor,
        ),
        Positioned(
          right: 70, // Positioning date at the top of the clock
          child: Text(
            DateFormat('EEE  d').format(DateTime.now()), // Date format Tue 17
            style: const TextStyle(
                color: textColor,
                fontSize: 28,
                backgroundColor: Colors.black26),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 16,
          child: Column(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: const BoxDecoration(
                    color: Colors.black26, shape: BoxShape.circle),
              ),
              Text(
                DateFormat('MMM').format(lastFullMoon),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                DateFormat('d').format(lastFullMoon),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 16,
          child: Column(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: const BoxDecoration(
                    color: textColor, shape: BoxShape.circle),
              ),
              Text(
                DateFormat('MMM').format(nextFullMoon),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                DateFormat('d').format(nextFullMoon),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }

  DateTime calculateLastFullMoon(DateTime now) {
    //! Reference full moon date (e.g., August 1, 2023)
    DateTime referenceFullMoon = DateTime(2023, 8, 1);
    double lunarCycleDays = 29.53;
    int daysSinceReference = now.difference(referenceFullMoon).inDays;
    int fullMoonsSinceReference = (daysSinceReference / lunarCycleDays).floor();
    return referenceFullMoon.add(
        Duration(days: (fullMoonsSinceReference * lunarCycleDays).round()));
  }

  DateTime calculateNextFullMoon(DateTime now) {
    DateTime lastFullMoon = calculateLastFullMoon(now);
    double lunarCycleDays = 29.53;
    return lastFullMoon.add(Duration(days: lunarCycleDays.round()));
  }
}
