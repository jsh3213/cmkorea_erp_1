import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:flutter/material.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:get/get.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

// ignore: must_be_immutable
class ImagePreview extends StatefulWidget {
  Product product;
  int index;
  String type;

  ImagePreview({
    Key? key,
    required this.product,
    required this.index,
    required this.type,
  }) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late final TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.serialNumber),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: true,
          minScale: 0.1,
          maxScale: 30.0,
          constrained: true,
          child: Image.network(
            widget.type == 'inImage' ? '$baseUrl/api${widget.product.inImage[widget.index].image}' : '$baseUrl/api${widget.product.outImage[widget.index].image}',
            width: width * 0.9,
            height: height * 0.9,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
