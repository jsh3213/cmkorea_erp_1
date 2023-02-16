import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/Image/index_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCheckScreen extends StatefulWidget {
  const ListCheckScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListCheckScreenState createState() => _ListCheckScreenState();
}

class _ListCheckScreenState extends State<ListCheckScreen> {
  DateTime _startedDate = DateTime.now();
  DateTime _endedDate = DateTime.now();
  static List<Product> products = [];

  Future<void> _startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startedDate) {
      setState(() {
        _startedDate = picked;
      });
    }
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endedDate) {
      setState(() {
        _endedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '기간 : ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () => _startDate(context),
                    child: Text(
                      '${_startedDate.year}-${_startedDate.month}-${_startedDate.day}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(' ~ '),
                  InkWell(
                    onTap: () => _endDate(context),
                    child: Row(
                      children: [
                        Text(
                          '${_endedDate.year}-${_endedDate.month}-${_endedDate.day}  ',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var response = await ProductApi.fetchByDateRange(
                            _startedDate, _endedDate);
                        setState(() {
                          products = [];
                          products = response
                              .where((element) =>
                                  element.repairTypeDecide == '수리타입 확인')
                              .toList();
                        });
                      },
                      child: const Text('검색'))
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = products[index];
                    return Column(
                      children: [
                        buildProduct(product, index),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
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
            const SizedBox(width: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.note),
            ),
          ],
        ),
        subtitle: Text(
          product.model,
        ),
        onTap: () {
          Get.to(() => UpdateScreen(
                product: products[index],
              ));
        },
      );
}
