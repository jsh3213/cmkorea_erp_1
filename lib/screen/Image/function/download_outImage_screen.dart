import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cmkorea_erp/api/product_api.dart';
import 'package:cmkorea_erp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class OutImageDownloadScreen extends StatefulWidget {
  Product product;
  OutImageDownloadScreen({
    super.key,
    required this.product,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OutImageDownloadScreenState createState() => _OutImageDownloadScreenState();
}

class _OutImageDownloadScreenState extends State<OutImageDownloadScreen> {
  late List<bool> _isSelected;
  bool wait = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final response = await ProductApi.productDetail(widget.product.id);
    setState(() {
      widget.product = response;
      _isSelected = List.filled(widget.product.outImage.length, false);
    });
  }

  void _handleCheckboxChanged(bool value, int index) {
    setState(() {
      _isSelected[index] = value;
    });
  }

  List<int> _getSelectedIndexes() {
    List<int> selectedIndexes = [];
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected[i]) {
        selectedIndexes.add(i);
      }
    }
    return selectedIndexes;
  }

  Future<String?> getAppDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {}
    return selectedDirectory;
  }

  Future<void> _downloadMultipleImages() async {
    List selecteImage = _getSelectedIndexes();
    String? directoryPath = await getAppDirectory();
    setState(() => wait = true);
    if (directoryPath == null) {
      setState(() => wait = false);
      return;
    }
    var directory = Directory(directoryPath).parent;
    await directory.create(recursive: true);
    for (int i = 0; i < selecteImage.length; i++) {
      var response = await http.get(Uri.parse(
          '$baseUrl/api${widget.product.outImage[selecteImage[i]].image}'));
      File file = File(
          "${directory.path}/${widget.product.serialNumber}_출고 이미지_$i.jpg");
      await file.writeAsBytes(response.bodyBytes);
    }
    _isSelected = List.filled(widget.product.outImage.length, false);
    setState(() => wait = false);
    Get.snackbar('완료', '', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('다운로드'),
      ),
      body: wait
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                      itemCount: widget.product.outImage.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Checkbox(
                                hoverColor: Colors.blue[100],
                                value: _isSelected[index],
                                onChanged: (value) {
                                  _handleCheckboxChanged(value!, index);
                                },
                              ),
                              SizedBox(
                                width: width * 0.3,
                                height: height * 0.2,
                                child: InkWell(
                                  onTap: () =>
                                      _handleCheckboxChanged(true, index),
                                  child: Image.network(
                                    '$baseUrl/api${widget.product.outImage[index].image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSelected = List.filled(
                                  widget.product.outImage.length, true);
                            });
                          },
                          child: const Text('전체 선택')),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSelected = List.filled(
                                  widget.product.outImage.length, false);
                            });
                          },
                          child: const Text('전체 취소')),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          child: const Text(
                            "사진 내려받기",
                            style: TextStyle(fontSize: 14),
                          ),
                          onPressed: () async {
                            _downloadMultipleImages();
                          }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
