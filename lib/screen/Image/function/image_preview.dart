import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

// ignore: must_be_immutable
class ImagePrevew extends StatelessWidget {
  Product product;
  int index;
  String type;
  ImagePrevew(
      {Key? key,
      required this.product,
      required this.index,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.serialNumber),
        centerTitle: true,
      ),
      body: PhotoView.customChild(
        enableRotation: true,
        child: Image.network(
          type == 'inImage'
              ? '$baseUrl/api${product.inImage[index].image}'
              : '$baseUrl/api${product.outImage[index].image}',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
