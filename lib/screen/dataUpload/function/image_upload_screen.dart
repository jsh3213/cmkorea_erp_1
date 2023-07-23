import 'dart:io';
import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageUploadScreen extends StatefulWidget {
  final Product product;
  final String status;

  const ImageUploadScreen({
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
  var response;

  void _openFilePicker() async {
    try {
      FilePickerResult? files = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);
      var file = files!.paths..toList().toString();
      setState(() {
        _images = file;
      });
    } catch (e) {}
  }

  void _showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Flutter Spinkit 패키지의 프로그래스 바 등록
        var spinkit = SpinKitCircle(
          color: Colors.blueAccent,
          size: 50.0,
        );

        return AlertDialog(
          content: SizedBox(
            height: 50,
            child: Center(child: spinkit),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('${widget.product.serialNumber} 이미지 업로드'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              _showProgressDialog(); // Show progress dialog
              await sendApi();
              if (response == 201) {
                Get.back(); // 프로그레스 다이얼로그를 닫음
                Get.back(result: true);
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
              }
            },
            child: const Text(
              '저장',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _images!.isEmpty
          ? const Center(child: Text('이미지 선택해 주세요!'))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10),
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

  sendApi() async {
    if (widget.status == 'inImage') {
      var value = await ProductApi.inImageCreate(widget.product.id, _images!);
      setState(() {
        response = value;
      });
    } else {
      var value = await ProductApi.outImageCreate(widget.product.id, _images!);
      setState(() {
        response = value;
      });
    }
  }
}
