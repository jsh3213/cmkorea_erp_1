import 'dart:async';
import 'package:cmkorea_erp/screen/list_screen.dart';
import 'package:cmkorea_erp/screen/update_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../../model/product.dart';
import '../api/product_api.dart';

class ListWaitScreen extends StatefulWidget {
  const ListWaitScreen({super.key});

  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<ListWaitScreen> {
  static List<Product> products = [];
  String query = '';
  Timer? debouncer;
  bool status = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
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
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('수리 타입 결정 (대기)'),
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
        ),
      );

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
