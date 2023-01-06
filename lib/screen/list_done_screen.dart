import 'dart:async';
import 'package:cmkorea_erp/screen/update_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../../model/product.dart';
import 'package:timer_builder/timer_builder.dart';

import '../controller/getxController.dart';

// ignore: must_be_immutable
class ListDoneScreen extends StatefulWidget {
  const ListDoneScreen({super.key});

  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<ListDoneScreen> {
  List<Product> products = [];
  String query = '';
  Timer? debouncer;
  final controller = Get.put(BuilderController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 1500)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future<List<Product>> init() async {
    await controller.getList();
    products = controller.products;
    return products;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('수리타입 (완료)'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  setState(() {
                    products.length;
                  });
                },
                icon: const Icon(Icons.replay))),
        body: Column(
          children: <Widget>[
            Expanded(
              child: TimerBuilder.periodic(
                const Duration(seconds: 60),
                builder: (context) {
                  return FutureBuilder<List<Product>>(
                    future: init(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('error'),
                        );
                      } else if (snapshot.hasData) {
                        return buildList(context);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
  Widget buildList(context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Column(
          children: [
            buildProduct(product, index),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget buildProduct(Product product, index) => ListTile(
        leading: Text(
          "${index + 1}",
        ),
        title: Row(
          children: [
            Text(
              product.serialNumber,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 100),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.note),
            ),
          ],
        ),
        subtitle: Text(
          product.model,
        ),
        onTap: () async {
          Get.to(() => UpdateScreen(
                product: products[index],
              ));
        },
      );
}
