import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:timer_builder/timer_builder.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../controller/getxController.dart';

final controller = Get.put(ReactiveController());

class TimeScreen extends StatefulWidget {
  const TimeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimeScreenState createState() => _TimeScreenState();
}

Timer? _timer;

class _TimeScreenState extends State<TimeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Container(
            color: controller.colorChange.value ? Colors.yellow : Colors.white,
            child: Center(
              child: TimerBuilder.periodic(const Duration(seconds: 30),
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
                    fontSize:
                        Theme.of(context).textTheme.displayMedium?.fontSize,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
