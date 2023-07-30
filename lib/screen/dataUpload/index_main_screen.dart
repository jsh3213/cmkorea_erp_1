import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/dataUpload/indexScreen/informationScreen/information_main_screen.dart';
import 'package:cmkorea_erp/screen/dataUpload/indexScreen/inImageScreen/inImage_screen.dart';
import 'package:cmkorea_erp/screen/dataUpload/indexScreen/outImageScreen/outImage_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IndexScreen extends StatefulWidget {
  Product product;

  IndexScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  IndexScreenState createState() => IndexScreenState();
}

class IndexScreenState extends State<IndexScreen> {
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
                const SizedBox(height: 10),
                TabBar(
                  labelStyle: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
              return InformationMainScreen(product: _);
            case 2:
              return InImageScreen(
                product: _,
              );
            case 3:
              return OutImageScreen(product: _);
            default:
          }
        })(),
      ),
    );
  }
}
