import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'controller/getxController.dart';
import 'screen/dataUpload/main_list_screen.dart';
import 'screen/operationRequest/operation_main_screen.dart';
import 'screen/repairDecide/repairTypeDecide_screen.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // 서버로부터 업데이트 정보 가져오기 함수
  Future<bool> checkUpdateAvailability() async {
    // final response = await http.get(Uri.parse('$baseUrl/api/updates'));
    final response = await http.get(Uri.parse('$baseUrl/api/updates')).catchError((error) => print(error));

    print(response);
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map<String, dynamic> updateData = json.decode(response.body);

      //   // 다운로드 가능한 새로운 버전이 있는지 확인
      if (updateData['isUpdateAvailable'] == true) {
        return true;
      }
    }
    return false;
  }

  Future<void> showUpdateDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새로운 업데이트가 있습니다.'),
          content: const Text('새로운 버전을 설치하려면 업데이트 버튼을 눌러주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('업데이트'),
              onPressed: () {
                // ignore: deprecated_member_use
                launch("$baseUrl/download"); // 사용자가 업데이트를 다운로드하고 설치할 수 있는 웹 페이지로 이동
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkUpdate(BuildContext context) async {
    final isUpdateAvailable = await checkUpdateAvailability();

    if (isUpdateAvailable) {
      await showUpdateDialog(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      navigatorKey: _navigatorKey,
      home: Builder(
        builder: (BuildContext ctx) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            _checkUpdate(_navigatorKey.currentContext!);
          });
          return const MyHomePage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _tabs = ['수리 타입 결정', '작업 요청 리스트', '사진 및 자료'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: null,
          centerTitle: false,
          toolbarHeight: 10.0,
          bottom: TabBar(
            labelStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 15.0),
            tabs: _tabs.map((String title) => Tab(text: title)).toList(),
          ),
        ),
        body: const TabBarView(
          children: [
            RepairTypeDecideScreen(),
            OperationMainScreen(),
            UploadMainScreen(),
          ],
        ),
      ),
    );
  }
}
