import 'dart:async';

import 'package:cmkorea_erp/screen/list_done_screen.dart';
import 'package:cmkorea_erp/screen/time_screen.dart';
import 'package:flutter/material.dart';
import 'api/product_api.dart';
import 'model/product.dart';
import 'screen/list_wait_screen.dart';
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

  void audioPlay() async {
    var response = await ProductApi.productList();
    setState(() {
      products = response
          .where((element) => element.repairTypeDecide == '완료')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(flex: 1, child: TimeScreen()),
            const Divider(),
            Expanded(
              flex: 4,
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const ListWaitScreen()),
                    Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const ListDoneScreen())
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
