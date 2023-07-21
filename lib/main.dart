import 'package:cmkorea_erp/screen/dataUpload/main_list_screen.dart';
import 'package:cmkorea_erp/screen/operationRequest/operation_main_screen.dart';
import 'package:cmkorea_erp/screen/productionSche/productionSchedule_screen.dart';
import 'package:cmkorea_erp/screen/repairDecide/repairTypeDecide_screen.dart';
import 'package:flutter/material.dart';
import 'model/product.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return DefaultTabController(
      length: 3,
      child: const Scaffold(
        body: SafeArea(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TabBar(
                    labelStyle:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(fontSize: 18.0),
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    tabs: [
                      Text('수리타입 결정'),
                      Text('작업 요청 리스트'),
                      Text('사진 & 자료'),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  RepairTypeDecideScreen(),
                  OperationMainScreen(),
                  UploadMainScreen(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
