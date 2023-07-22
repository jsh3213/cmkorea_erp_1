import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:cmkorea_erp/screen/dataUpload/function/download_inImage_screen.dart';
import 'package:cmkorea_erp/screen/dataUpload/function/image_preview.dart';
import 'package:cmkorea_erp/screen/dataUpload/function/image_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  _InImageScreenState createState() => _InImageScreenState();
}

class _InImageScreenState extends State<InImageScreen> {
  TextEditingController controllerText = TextEditingController();
  late List<Product> images;
  final Set<int> _selectedImages = {};

  void _onImageSelected(int index, bool isLongPressed) {
    setState(() {
      if (_selectedImages.contains(index)) {
        _selectedImages.remove(index);
      } else {
        _selectedImages.add(index);
      }
      if (isLongPressed) toggleAppBar();
    });
  }

  bool isSelectMode = false;
  void toggleAppBar() {
    setState(() {
      isSelectMode = !isSelectMode;
      if (!isSelectMode) {
        _selectedImages.clear();
      }
    });
  }

  void _selectAllImages() {
    setState(() {
      if (_selectedImages.length == widget.product.inImage.length) {
        _selectedImages.clear();
      } else {
        for (int i = 0; i < widget.product.inImage.length; i++) {
          _selectedImages.add(i);
        }
      }
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    final response = await ProductApi.productDetail(widget.product.id);
    if (mounted) {
      setState(() {
        widget.product = response;
      });
    }
  }

  Future<void> _onImageDelete() async {
    const String password = '1111';
    String? inputPassword;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('비밀번호를 입력하세요'),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              inputPassword = value;
            },
            decoration: const InputDecoration(labelText: '비밀번호'),
          ),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () async {
                if (inputPassword == password) {
                  for (int index in _selectedImages) {
                    await ProductApi.inImageDelete(widget.product.inImage[index].id);
                  }
                  _selectedImages.clear();
                  toggleAppBar();
                  init(); // 새로고침 및 상태 초기화
                  Navigator.of(context).pop();
                  Get.snackbar('성공', '이미지가 삭제되었습니다.');
                } else {
                  Get.snackbar('오류', '비밀번호가 틀렸습니다.');
                }
              },
            ),
          ],
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
        automaticallyImplyLeading: false,
        title: const Text('제품 이미지'),
        centerTitle: true,
        actions: [
          if (isSelectMode)
            IconButton(
                onPressed: _selectAllImages,
                icon: Icon(
                  _selectedImages.length == widget.product.inImage.length ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                  color: Colors.white,
                )),
          if (isSelectMode) Container(alignment: Alignment.center, child: const Text('전체 선택/해체')),
          const SizedBox(
            width: 50,
          ),
          if (isSelectMode)
            IconButton(
                onPressed: () async {
                  _onImageDelete();
                },
                icon: const Icon(Icons.delete)),
          if (isSelectMode) Container(alignment: Alignment.center, child: const Text('삭제')),
          const SizedBox(
            width: 20,
          ),
          if (isSelectMode) IconButton(onPressed: toggleAppBar, icon: const Icon(Icons.cancel)),
          if (isSelectMode) Container(alignment: Alignment.center, child: const Text('취소')),
          if (!isSelectMode) IconButton(onPressed: () => init(), icon: const Icon(Icons.refresh)),
          const SizedBox(
            width: 20,
          ),
        ],
        backgroundColor: (isSelectMode) ? Colors.red : Colors.blue,
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemCount: widget.product.inImage.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isSelected = _selectedImages.contains(index);

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onDoubleTap: () {
                              if (!isSelectMode) {
                                Get.to(ImagePreview(
                                  product: widget.product,
                                  index: index,
                                  type: 'inImage',
                                ));
                              }
                            },
                            onTap: () {
                              if (isSelectMode) {
                                _onImageSelected(index, false);
                              }
                            },
                            onLongPress: () {
                              _onImageSelected(index, true);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  width: width * 0.4,
                                  height: height * 0.6,
                                  '$baseUrl/api${widget.product.inImage[index].image}',
                                  fit: BoxFit.cover,
                                ),
                                if (isSelected)
                                  Container(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                if (isSelected) const Icon(Icons.check_circle, color: Colors.blue, size: 100),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (int index) {
          if (index == 0) {
            Get.to(ImageUploadScreen(
              product: widget.product,
              status: 'inImage',
            ))?.then((result) {
              if (result == true) {
                init();
              }
            });
          } else {
            Get.to(InImageDownloadScreen(product: widget.product));
          }
        },
        items: const [
          BottomNavigationBarItem(label: '사진 업로드', icon: Icon(Icons.upload)),
          BottomNavigationBarItem(label: '사진 다운로드', icon: Icon(Icons.download)),
        ],
      ),
    );
  }
}
