import 'dart:async';
import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/dataUpload/index_main_screen.dart';
import 'package:cmkorea_erp/widget/search_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class UploadMainScreen extends StatefulWidget {
  const UploadMainScreen({super.key});

  @override
  UploadMainScreenState createState() => UploadMainScreenState();
}

class UploadMainScreenState extends State<UploadMainScreen> {
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
          Get.to(() => IndexScreen(product: product));
        },
      );
}
