import 'dart:async';
import 'dart:io';
import 'package:cmkorea_erp/screen/list_screen.dart';
import 'package:cmkorea_erp/screen/update_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../../model/product.dart';
import '../api/product_api.dart';
import 'package:timer_builder/timer_builder.dart';

class ListWaitScreen extends StatefulWidget {
  const ListWaitScreen({super.key});

  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<ListWaitScreen> {
  static List<Product> products = [];
  String query = '';
  bool status = true;
  static Timer? _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future init() async {
    setState(() => status = true);
    var response = await ProductApi.productList();
    setState(() {
      products = response
          .where((element) =>
              element.repairTypeDecide == '대기' ||
              element.repairTypeDecide == '현업 대기')
          .toList();
    });
    setState(() => status = false);
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      getList();
    });
  }

  void getList() async {
    var response = await ProductApi.productList();
    setState(() {
      products = response
          .where((element) =>
              element.repairTypeDecide == '대기' ||
              element.repairTypeDecide == '현업 대기')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('수리 타입 결정(대기) 수량: ${products.length}'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.to(() => const ListScreen());
            },
            icon: const Icon(Icons.add)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: status
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Column(
                        children: [
                          buildList(product, index),
                          const Divider(),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ));

  Widget buildList(Product product, index) => ListTile(
        leading: Text(
          "${index + 1}",
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.serialNumber.toString(),
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              product.repairTypeDecide.toString(),
            )
          ],
        ),
        subtitle: Text(
          product.model.toString(),
        ),
        onTap: () async {
          Get.to(() => UpdateScreen(product: products[index]));
        },
      );
}
