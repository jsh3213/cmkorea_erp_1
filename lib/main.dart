import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:cmkorea_erp/downloadpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkForUpdates();
  }

  Future<void> checkForUpdates() async {
    try {
      final response = await http.get(
          Uri.parse('#baseUrl/yourapp/version.json'),
          headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final latestVersion = jsonResponse["latest_version"];
        final currentVersion = "1.0.0";

        if (latestVersion != currentVersion) {
          final updateUrl = jsonResponse["url"];
          if (await canLaunch(updateUrl)) {
            await launch(updateUrl);
          } else {
            throw 'Could not launch $updateUrl';
          }
        } else {
          print("No updates available.");
        }
      } else {
        throw Exception('Failed to fetch update information.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            TextButton(
                onPressed: () {
                  Get.to(DownloadPage());
                },
                child: Text('download'))
          ],
        ),
      ),
    );
  }
}
