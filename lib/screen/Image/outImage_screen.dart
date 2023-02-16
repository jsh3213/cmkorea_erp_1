import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/Image/function/download_outImage_screen.dart';
import 'package:cmkorea_erp/screen/Image/function/image_preview.dart';
import 'package:cmkorea_erp/screen/Image/function/image_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

// ignore: must_be_immutable
class OutImageScreen extends StatefulWidget {
  Product product;

  OutImageScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OutImageScreenState createState() => _OutImageScreenState();
}

class _OutImageScreenState extends State<OutImageScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  TextEditingController controllerText = TextEditingController();
  late List<Product> images;

  Future init() async {
    final response = await ProductApi.productDetail(widget.product.id);

    setState(() {
      widget.product = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
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
                      itemCount: widget.product.outImage.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            child: Image.network(
                              '$baseUrl/api${widget.product.outImage[index].image}',
                              fit: BoxFit.cover,
                            ),
                            onDoubleTap: () {
                              Get.to(ImagePrevew(
                                product: widget.product,
                                index: index,
                                type: 'outImage',
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
                                        '$baseUrl/api${widget.product.outImage[index].image}',
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
                                        await ProductApi.outImageDelete(
                                            widget.product.outImage[index].id);

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
            Get.to(
              ImageUploadScreen(
                product: widget.product,
                status: 'outImage',
              ),
            );
          } else {
            Get.to(OutImageDownloadScreen(
              product: widget.product,
            ));
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
