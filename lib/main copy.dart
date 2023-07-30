// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:install_plugin/install_plugin.dart';
// import 'package:cmkorea_erp/controller/getxController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// import 'screen/dataUpload/main_list_screen.dart';
// import 'screen/operationRequest/operation_main_screen.dart';
// import 'screen/repairDecide/repairTypeDecide_screen.dart';

// final controller = Get.put(ReactiveController());
// final baseUrl = controller.baseUrl;

// Future<void> checkForUpdates() async {
//   final packageInfo = await PackageInfo.fromPlatform();
//   final currentVersion = packageInfo.version;

//   final response = await http.get(Uri.parse('$baseUrl/api/appinfo/'));
//   final jsonResponse = json.decode(response.body);
//   final serverVersion = jsonResponse['version'];
//   final apkUrl = '$baseUrl/meia/apks/app-release.apk';
//   print(currentVersion);
//   print(serverVersion);
//   print(apkUrl);

//   if (serverVersion == currentVersion) {
//     return;
//   }

//   final tempDir = await Directory.systemTemp.createTemp();
//   final apkFile = File('${tempDir.path}/app-release.apk');
//   final apkResponse = await http.get(Uri.parse(apkUrl));
//   await apkFile.writeAsBytes(apkResponse.bodyBytes);
//   print(apkFile.path);

//   try {
//     await InstallPlugin.installApk(apkFile.path);
//     print('Install success');
//   } catch (e) {
//     print('Error in installApk: $e');
//   }
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
//   await checkForUpdates();
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final List<String> _tabs = ['수리 타입 결정', '작업 요청 리스트', '사진 및 자료'];
//   String? _currentVersion;

//   @override
//   void initState() {
//     super.initState();
//     _initPackageInfo();
//   }

//   Future<void> _initPackageInfo() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       _currentVersion = packageInfo.version;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: _tabs.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'cmkorea_erp v$_currentVersion',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: false,
//           toolbarHeight: 30.0,
//           bottom: TabBar(
//             labelStyle:
//                 const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//             unselectedLabelStyle: const TextStyle(fontSize: 15.0),
//             tabs: _tabs.map((String title) => Tab(text: title)).toList(),
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             RepairTypeDecideScreen(),
//             OperationMainScreen(),
//             UploadMainScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }
