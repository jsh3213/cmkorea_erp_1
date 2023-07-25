import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'screen/dataUpload/main_list_screen.dart';
import 'screen/operationRequest/operation_main_screen.dart';
import 'screen/repairDecide/repairTypeDecide_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../controller/getxController.dart';



final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String localVersion = packageInfo.version;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MyApp(localVersion: localVersion),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.localVersion}) : super(key: key);

  final String localVersion;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // final String baseUrl = 'http://your-server-domain.com or IP 서버주소 여기에 입력하셔야합니다.';
  late String downloadUrl;

  @override
  void initState() {
    super.initState();
    downloadUrl = baseUrl + '/download/cmkorea_erp_' + widget.localVersion + '.msix';
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext ctx) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          checkAndUpdate(context);
        });
        return MyHomePage();
      },
    );
  }

  Future<void> checkAndUpdate(BuildContext context) async {
    String serverVersion = '1.0.1'; // 서버의 버전을 직접 입력하세요.

    if (widget.localVersion != serverVersion) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String filePath = '$appDocPath/cmkorea_erp_$serverVersion.msix';

      if (File(filePath).existsSync()) {
        // 삭제하려면 emit을 사용하세요.
        File(filePath).deleteSync();
        updateApp(filePath);
      } else {
        downloadAndInstallApp(serverVersion);
      }
    }
  }

  void updateApp(String filePath) async {
    if (await canLaunch(filePath)) {
      await launch(filePath);
    } else {
      print('Cannot launch $filePath');
    }
  }

  Future<void> downloadAndInstallApp(String serverVersion) async {
    http.Response response = await http.get(Uri.parse(downloadUrl));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    File file = File('$appDocPath/cmkorea_erp_$serverVersion.msix');
    await file.writeAsBytes(response.bodyBytes);
    updateApp(file.path);
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
            labelStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
