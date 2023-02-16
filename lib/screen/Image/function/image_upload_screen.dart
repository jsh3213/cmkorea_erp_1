import 'dart:io';
import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';

// ignore: must_be_immutable
class ImageUploadScreen extends StatefulWidget {
  Product product;
  String status;
  ImageUploadScreen({
    Key? key,
    required this.product,
    required this.status,
  }) : super(key: key);

  @override
  ImageUploadScreenState createState() => ImageUploadScreenState();
}

class ImageUploadScreenState extends State<ImageUploadScreen> {
  TextEditingController controllerText = TextEditingController();
  List? _images = [];

  void _openFilePicker() async {
    try {
      FilePickerResult? files = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);
      var a = files!.paths..toList().toString();
      setState(() {
        _images = a;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.product.serialNumber} 이미지 업로드'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              await sendApi();
              Get.back();
              _images!.isEmpty
                  ? null
                  : Get.showSnackbar(
                      GetSnackBar(
                        title: widget.product.serialNumber,
                        message: '저장 완료',
                        duration: const Duration(seconds: 2),
                        snackPosition: SnackPosition.TOP,
                      ),
                    );
            },
            child: const Text(
              '저장',
              style: TextStyle(color: (Colors.white), fontSize: 18),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _images!.isEmpty
          ? const Center(child: Text('이미지 선택해 주세요!'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _images!.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    previewImages(index, width, height)
                  ],
                );
              },
            ),
      bottomNavigationBar: Container(
          height: height * 0.05,
          color: Colors.blue,
          child: ElevatedButton(
            onPressed: () => _openFilePicker(),
            child: const Text(
              '이미지 선택',
              style: TextStyle(fontSize: 14),
            ),
          )),
    );
  }

  Widget previewImages(int index, double width, double height) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Image.file(
            File(_images![index]),
            fit: BoxFit.cover,
            width: width * 0.45,
            height: height * 0.2,
          ),
        ),
      ],
    );
  }

  sendApi() {
    if (widget.status == 'inImage') {
      ProductApi.inImageCreate(widget.product.id, _images!);
    } else {
      ProductApi.outImageCreate(widget.product.id, _images!);
    }
  }
}
