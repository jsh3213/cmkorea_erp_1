import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controller/getxController.dart';
import '../../main.dart';

final controller = Get.put(ReactiveController());

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('깜빡임'),
                Switch(
                    value: controller.settingColor.value,
                    onChanged: (_) => controller.settingColor.value =
                        !controller.settingColor.value),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('알람   '),
                Switch(
                    value: controller.settingAlarm.value,
                    onChanged: (_) => controller.settingAlarm.value =
                        !controller.settingAlarm.value),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Get.offAll(MyHomePage());
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text('확인')))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
