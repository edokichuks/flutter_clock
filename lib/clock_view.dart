// import 'package:moon_phase/moon_widget.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:intl/intl.dart';

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
  final textColor = Color.fromARGB(255, 199, 175, 154);
  final dividerColor = Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime utcTime = now.toUtc();
    bool isAM = now.hour < 12;
    final screenWidth = MediaQuery.sizeOf(context).width;

    DateTime nextNewMoon = now;
    DateTime nextFullMoon = now;

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
            Divider(
              color: dividerColor,
              height: 4,
            ),
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
                  "${DateFormat('hh:mm').format(now)}",
                  style: const TextStyle(fontSize: 64, color: Colors.white),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  children: [
                    Text(
                      "${DateFormat('ss').format(now)}",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      "+${(milliseconds * 1000).toInt()}",
                      style: TextStyle(color: textColor),
                    ),
                  ],
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
            Divider(
              color: dividerColor,
              height: 4,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                          "${DateFormat('HH:mm').format(now)}",
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
                  color: dividerColor,
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
                          const Text(
                            "2016",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          Text(
                            "NEXT LEAP YEAR",
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      LeapYearIndicator()
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Divider(
              color: dividerColor,
              height: 4,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomAnalogClock(),
            // AnalogClock(
            //   child: Icon(Icons.access_alarm_outlined),
            //   hourHandColor: Colors.white,
            //   minuteHandColor: Colors.white,
            //   secondHandColor: textColor,
            //   dialColor: Colors.transparent,
            //   markingColor: Colors.white,
            //   dialBorderColor: Colors.green,
            // ),

            // Padding(
            //   padding: const EdgeInsets.all(30.0),
            //   child: Wrap(
            //     spacing: 10,
            //     runSpacing: 10,
            //     direction: Axis.horizontal,
            //     children: _moonPhases(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // _moonPhases() {
  //   var _list = <Widget>[];
  //   for (int i = 0; i < 30 * (24 / 12); i++) {
  //     _list.add(
  // MoonWidget(
  //   date: DateTime(2021, 10, 6, 5).add(Duration(hours: i * 12)),
  //   resolution: 64,
  //   size: 48,
  //   moonColor: Colors.amber,
  //   earthshineColor: Colors.blueGrey.shade900,
  // ),
  //     );
  //   }
  //   return _list;
  // }
}

class LeapYearIndicator extends StatelessWidget {
  const LeapYearIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Color.fromARGB(255, 199, 175, 154);
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
  @override
  Widget build(BuildContext context) {
    final textColor = Color.fromARGB(255, 199, 175, 154);
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            bottom: 70, // Positioning moon icon at 6:00 PM
            child: Container(
              height: 70,
              width: 70,
              decoration:
                  BoxDecoration(color: textColor, shape: BoxShape.circle),
            )),
        AnalogClock(
          child: Icon(Icons.access_alarm_outlined),
          hourHandColor: Colors.white,
          minuteHandColor: Colors.white,
          secondHandColor: textColor,
          dialColor: Colors.transparent,
          markingColor: Colors.white,
          dialBorderColor: Colors.green,
        ),
        Positioned(
          right: 70, // Positioning date at the top of the clock
          child: Text(
            "${DateFormat('EEE  d').format(DateTime.now())}", // Date format Tue 17
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
                decoration: BoxDecoration(
                    color: Colors.black26, shape: BoxShape.circle),
              ),
              Text(
                "${DateFormat('EEE').format(DateTime.now())}",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${DateFormat('d').format(DateTime.now())}",
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
                "${DateFormat('EEE').format(DateTime.now())}",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${DateFormat('d').format(DateTime.now())}",
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
}
