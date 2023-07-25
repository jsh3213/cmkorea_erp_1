import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller/getxController.dart';
import 'screen/dataUpload/main_list_screen.dart';
import 'screen/operationRequest/operation_main_screen.dart';
import 'screen/repairDecide/repairTypeDecide_screen.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

Future<Directory?> getSupportedPath() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return getApplicationDocumentsDirectory();
  } else {
    return getExternalStorageDirectory();
  }
}

Future<void> checkForUpdates() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  final response = await http.get(Uri.parse('$baseUrl/api/appinfo/'));
  final jsonResponse = json.decode(response.body);
  final serverVersion = jsonResponse['version'];
  final apkUrl = jsonResponse['url'];

  if (serverVersion != currentVersion) {
    final externalDir = await getSupportedPath();
    final apkFile = File('${externalDir!.path}/app-release.apk');
    final apkResponse = await http.get(Uri.parse(apkUrl));
    await apkFile.writeAsBytes(apkResponse.bodyBytes);

    if (await canLaunchUrl(Uri.parse(apkFile.path))) {
      await launch(apkFile.path);
    } else {
      print('Could not launch apk file.');
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkForUpdates();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        navigatorKey: _navigatorKey,
        home: const MyHomePage());
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
        ));
  }
}
