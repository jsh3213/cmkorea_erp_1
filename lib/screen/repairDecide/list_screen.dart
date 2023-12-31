import 'dart:async';
import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/repairDecide/update_screen.dart';
import 'package:cmkorea_erp/widget/search_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<ListScreen> {
  TextEditingController controller = TextEditingController();

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

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future init() async {
    setState(() => status = true);
    var response = await ProductApi.productListSearch(query);
    setState(() => products = response);
    setState(() => status = false);
    const Duration(milliseconds: 200);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('목록'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            init();
          },
          child: Column(
            children: <Widget>[
              buildSearch(),
              Expanded(
                child: status
                    ? const Center(
                        child: CircularProgressIndicator(
                          // valueColor: AlwaysStoppedAnimation(Colors.green),
                          // backgroundColor: Colors.grey,
                          strokeWidth: 4,
                        ),
                      )
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return buildProduct(product, index);
                        },
                      ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       Get.toNamed('/create');
        //     },
        //     tooltip: 'Crate',
        //     child: Icon(Icons.add)),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search',
        onChanged: searchProducts,
      );

  Future searchProducts(String query) async => debounce(() async {
        var response = await ProductApi.productListSearch(query);
        if (!mounted) return;
        setState(() {
          this.query = query;
          products = response;
        });
      });

  Widget buildProduct(Product product, index) => ListTile(
        leading: Text("${index + 1}"),
        //     Image.network(
        //   product.inImage[0].image,
        //   fit: BoxFit.cover,
        //   width: 10,
        //   height: 10,
        // ),

        title: Row(
          children: [
            Text(
              product.serialNumber,
            ),
            const SizedBox(width: 10),
          ],
        ),
        subtitle: Text(
          product.model,
        ),
        onTap: () {
          Get.off(() => UpdateScreen(product: products[index]));
        },
        // trailing: IconButton(
        //   icon: const Icon(Icons.delete),
        //   onPressed: () {
        //     Get.defaultDialog(
        //       title: 'S/N: ${products[index].serialNumber}',
        //       // titleStyle: TextStyle(fontSize: 15),
        //       content: TextField(
        //         controller: controller,
        //         decoration: const InputDecoration(labelText: "cmk 입력하세요."),
        //         textInputAction: TextInputAction.done,
        //       ),
        //       confirmTextColor: Colors.white,
        //       textCancel: "취소",
        //       textConfirm: "삭제",

        //       onCancel: () {
        //         controller.text = "";
        //         Get.back();
        //       },
        //     );
        //   },
        // ),
      );
}
