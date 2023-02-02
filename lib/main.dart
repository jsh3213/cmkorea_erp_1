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
  final List _tabList = [
    '수리타입 결정',
    '작업 요청 리스트',
    '생산 계획',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return DefaultTabController(
      length: _tabList.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                // isScrollable: true,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: List.generate(
                  _tabList.length,
                  (int index) {
                    return Tab(
                      height: 50,
                      text: _tabList[index],
                    );
                  },
                ),
              ),
              const Expanded(
                  child: TabBarView(
                children: [
                  RepairTypeDecideScreen(),
                  OperationMainScreen(),
                  ScheduleScreen(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
