import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:timer_builder/timer_builder.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TimerBuilder.periodic(const Duration(seconds: 60),
              builder: (context) {
            return Text(
              DateFormat('yyyy'
                      '년'
                      'MM'
                      '월'
                      'dd'
                      '일'
                      '   '
                      'hh'
                      ':'
                      'mm'
                      ' '
                      'a')
                  .format(DateTime.now()),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
              ),
            );
          }),
        ),
      ),
    );
  }
}
