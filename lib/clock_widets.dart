import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:intl/intl.dart';
import 'package:moon_phase_plus/moon_widget.dart';



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
    final textColor = const Color.fromARGB(255, 199, 175, 154);
    DateTime now = DateTime.now();
    int currentYear = now.year;

    // Find the next leap year
    int nextLeapYear = currentYear;
    while (!isLeapYear(nextLeapYear)) {
      nextLeapYear++;
    }

    // Determine the arrow position
    int arrowPosition = (nextLeapYear - currentYear);
    if (arrowPosition > 3) {
      arrowPosition =
          1; // For cases where the next leap year is more than 3 years away
    } else if (arrowPosition == 0) {
      arrowPosition = 4; // Position L (current leap year)
    }

    return SizedBox(
      height: 80,
      width: 80,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // North
            Positioned(
              top: 0,
              child: Text(
                '1',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            // East
            Positioned(
              right: 0,
              child: Text(
                '2',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            // South
            Positioned(
              bottom: 0,
              child: Text(
                '3',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            // West
            Positioned(
              left: 0,
              child: Text(
                'L',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            // Arrow indicating the year
            Positioned(
              top: arrowPosition == 1
                  ? -15
                  : arrowPosition == 3
                      ? 15
                      : 0,
              right: arrowPosition == 2
                  ? -15
                  : arrowPosition == 1 || arrowPosition == 3
                      ? 0
                      : 15,
              bottom: arrowPosition == 3 ? -15 : 0,
              left: arrowPosition == 4
                  ? 15
                  : arrowPosition == 2 || arrowPosition == 4
                      ? 0
                      : 15,
              child: Icon(
                Icons.arrow_upward_rounded,
                size: 16,
                color: textColor,
              ),
            ),
          ],
        ),
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

    final textColor = const Color.fromARGB(255, 255, 194, 141);
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 70,
          child: Center(
            child: MoonWidget(
              date: DateTime.now(),
              resolution: 64,
              size: 70,
              moonColor: textColor,
              earthshineColor: Colors.blueGrey.shade900,
            ),
          ),
        ),
        AnalogClock(
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
            style: TextStyle(
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
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                DateFormat('d').format(lastFullMoon),
                style: TextStyle(
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
                decoration:
                    BoxDecoration(color: textColor, shape: BoxShape.circle),
              ),
              Text(
                DateFormat('MMM').format(nextFullMoon),
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                DateFormat('d').format(nextFullMoon),
                style: TextStyle(
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


