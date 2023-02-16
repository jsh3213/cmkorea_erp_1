import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/Image/function/data_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InformationScreen extends StatefulWidget {
  Product product;

  InformationScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> {
  bool wait = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: DataScreen(product: widget.product)),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('List Item ${index + 1}'),
                    subtitle: Text('Subtitle ${index + 1}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildView(Product _) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DataScreen(product: _),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DataScreen(product: _),
          ),
        ),
      ],
    );
  }
}
