import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/dataUpload/function/download_inImage_screen.dart';
import 'package:cmkorea_erp/screen/dataUpload/function/image_preview.dart';
import 'package:cmkorea_erp/screen/dataUpload/function/image_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

// ignore: must_be_immutable
class InImageScreen extends StatefulWidget {
  Product product;

  InImageScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InImageScreenState createState() => _InImageScreenState();
}

class _InImageScreenState extends State<InImageScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  TextEditingController controllerText = TextEditingController();
  late List<Product> images;

  Future init() async {
    final response = await ProductApi.productDetail(widget.product.id);

    if (mounted) {
      // 여기서 위젯의 dispose 상태를 확인
      setState(() {
        widget.product = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        // AppBar 추가
        backgroundColor: Colors.blue,
        title: const Text('제품 이미지'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              init();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: widget.product.inImage.isEmpty
                  ? const Center(
                      child: Text('No Images'),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemCount: widget.product.inImage.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            child: Image.network(
                              '$baseUrl/api${widget.product.inImage[index].image}',
                              fit: BoxFit.cover,
                            ),
                            onDoubleTap: () {
                              Get.to(ImagePrevew(
                                product: widget.product,
                                index: index,
                                type: 'inImage',
                              ));
                            },
                            onLongPress: () {
                              Get.defaultDialog(
                                title: widget.product.serialNumber,
                                content: Column(
                                  children: [
                                    SizedBox(
                                      width: width * 0.4,
                                      height: height * 0.6,
                                      child: Image.network(
                                        fit: BoxFit.cover,
                                        '$baseUrl/api${widget.product.inImage[index].image}',
                                      ),
                                    ),
                                    TextField(
                                      controller: controllerText,
                                      decoration: const InputDecoration(
                                          labelText: "password 입력하세요."),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ],
                                ),
                                confirmTextColor: Colors.white,
                                textConfirm: '삭제',
                                textCancel: '취소',
                                onConfirm: () async {
                                  if (controllerText.text == '1111') {
                                    int statusCode =
                                        await ProductApi.inImageDelete(
                                            widget.product.inImage[index].id);

                                    if (statusCode == 200) {
                                      Get.back();
                                      controllerText.text = "";
                                      Get.snackbar('삭제', '',
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  } else {
                                    controllerText.text = "";
                                    Get.back();
                                    Get.snackbar('실패', '',
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                              ).then((value) => init());
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.blue,
        // selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 14,

        onTap: (int index) {
          if (index == 0) {
            Get.to(ImageUploadScreen(
              product: widget.product,
              status: 'inImage',
            ));
          } else {
            Get.to(InImageDownloadScreen(product: widget.product));
          }
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
              label: '사진 업로드', icon: Icon(Icons.upload)),
          const BottomNavigationBarItem(
              label: '사진 다운로드', icon: Icon(Icons.download)),
        ],
      ),
    );
  }
}

class $ {}
