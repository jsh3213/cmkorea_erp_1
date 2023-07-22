// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class ReactiveController extends GetxController {
  // String baseUrl = "http://14.47.200.173:8888";
  String baseUrl = "http://127.0.0.1:8000";
  RxBool colorChange = false.obs;
  RxBool settingColor = true.obs;
  RxBool settingAlarm = true.obs;

  get color => settingColor;
}
