import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/Image/function/download_inImage_screen.dart';
import 'package:cmkorea_erp/screen/Image/information_screen.dart';
import 'package:cmkorea_erp/screen/Image/outImage_screen.dart';
import 'package:cmkorea_erp/screen/Image/inImage_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UpdateScreen extends StatefulWidget {
  Product product;

  UpdateScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  UpdateScreenState createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateScreen> {
  final List _tabList = ['정보', '입고사진', '출고사진'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.serialNumber),
      ),
      body: DefaultTabController(
        length: _tabList.length,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 70),
                TabBar(
                  labelStyle: const TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 15.0),
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: List.generate(
                    _tabList.length,
                    (int index) {
                      return Tab(
                        text: _tabList[index],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      buildView(widget.product, 1),
                      buildView(widget.product, 2),
                      buildView(widget.product, 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildView(Product _, index) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5),
      // decoration: BoxDecoration(
      // border: Border.all(width: 1, color: Colors.black),
      // borderRadius: BorderRadius.circular(5),
      // ),
      child: Center(
        child: (() {
          switch (index) {
            case 1:
              return InformationScreen(product: _);
            case 2:
              return InImageScreen(product: _);
            case 3:
              return OutImageScreen(product: _);
            default:
          }
        })(),
      ),
    );
  }
}
