import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/dataUpload/indexScreen/informationScreen/data_screen.dart';
import 'package:cmkorea_erp/screen/dataUpload/indexScreen/informationScreen/document_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InformationMainScreen extends StatefulWidget {
  Product product;

  InformationMainScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  InformationMainScreenState createState() => InformationMainScreenState();
}

class InformationMainScreenState extends State<InformationMainScreen> {
  bool wait = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: DataScreen(
              product: widget.product,
            ),
          ),
          Expanded(
            flex: 1,
            child: DocumentScreen(product: widget.product),
          ),
        ],
      ),
    );
  }
}
