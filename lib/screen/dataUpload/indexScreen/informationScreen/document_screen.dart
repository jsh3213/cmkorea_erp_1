import 'package:cmkorea_erp/model/product.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// ignore: must_be_immutable
class DocumentScreen extends StatefulWidget {
  Product product;
  DocumentScreen({
    super.key,
    required this.product,
  });

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List? _files = [];
  final TextEditingController _controller = TextEditingController();
  String _text = '';

  Future<void> uploadImage(File imageFile) async {
    // Django API 엔드포인트 URL 설정
    final url = Uri.parse('http://example.com/api/upload-image/');

    // 파일을 바이트 배열로 읽어옴
    List<int> imageBytes = await imageFile.readAsBytes();

    // 파일 이름 설정 (예시)
    final fileName = 'my_image.jpg';

    // FormData 객체 생성
    final request = http.MultipartRequest('POST', url)
      ..fields['file_name'] = fileName
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes,
          filename: fileName));

    // 요청 보내기
    final response = await request.send();

    // 응답 확인
    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image.');
    }
  }

  void _openFilePicker() async {
    setState(() {
      _text = '';
    });
    try {
      FilePickerResult? file = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.any);
      setState(() {
        _text = file!.paths.toString();
      });
      Get.back();
      getDialog();

      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('관서 문서'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _text = '';
                      });
                      getDialog();
                    },
                    child: const Text('자료 올리기'),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('List Item ${index + 1}'),
                      subtitle: Text('Subtitle ${index + 1}'),
                      trailing: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getDialog() {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    return Get.defaultDialog(
      title: '파일 저장',
      content: SizedBox(
        width: width * 0.5,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    '파일 :',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    // margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(_text),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _openFilePicker();
                    },
                    child: const Text('검색'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    '비고 :',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Get.back();
        },
        child: const Text('취소'),
      ),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: const Text('저장'),
      ),
    );
  }
}
