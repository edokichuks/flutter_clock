import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter_clock/clock_widets.dart';
import 'package:intl/intl.dart';
import 'package:moon_phase_plus/moon_phase_plus.dart';
import 'package:moon_phase_plus/moon_widget.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  double milliseconds = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        milliseconds = (DateTime.now().millisecondsSinceEpoch % 1000) / 1000;
      });
    });
  }

  final mainColor = const Color(0xff2A2A28);
  final textColor = const Color.fromARGB(255, 255, 194, 141);
  // final dividerColor = Colors.grey.shade600;
  int nextLeapYear = DateTime.now().year;

  void nextLeapYearCal() {
    DateTime now = DateTime.now();
    int yearsUntilLeapYear = 4 - (now.year % 4);

    if (yearsUntilLeapYear == 0) {
      nextLeapYear = now.year;
    } else {
      nextLeapYear = now.year + yearsUntilLeapYear;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    nextLeapYearCal();
    bool isAM = now.hour < 12;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(
          'Time',
          style: TextStyle(color: textColor, fontSize: 24),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const ClockDivider(),
            const SizedBox(
              height: 4,
            ),
            Text(
              'CEST',
              style: TextStyle(color: textColor, fontSize: 24),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "AM",
                      style: TextStyle(
                          color: isAM ? textColor : Colors.grey.shade800,
                          fontSize: 20),
                    ),
                    Text(
                      "PM",
                      style: TextStyle(
                          color: !isAM ? textColor : Colors.grey.shade800,
                          fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  DateFormat('hh:mm').format(now),
                  style: const TextStyle(fontSize: 64, color: Colors.white),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 50,
                  child: Column(
                    children: [
                      Text(
                        DateFormat('ss').format(now),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        "+${(milliseconds * 1000).toInt()}",
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              'ATOMIC TIME SYNCED',
              style: TextStyle(color: textColor, fontSize: 20),
            ),
            const SizedBox(
              height: 4,
            ),
            const ClockDivider(),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(now),
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                        Text(
                          "UTC",
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: 2,
                  color: Colors.grey.shade600,
                  margin: EdgeInsets.zero,
                ),
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            nextLeapYear.toString(),
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                          Text(
                            "NEXT LEAP YEAR",
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      const LeapYearIndicator()
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            const ClockDivider(),
            const SizedBox(
              height: 8,
            ),
            const CustomAnalogClock(),
          ],
        ),
      ),
    );
  }
}
