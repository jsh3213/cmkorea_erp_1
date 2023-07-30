import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<String> files = [];
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  Future<void> fetchFiles() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/media/apk/'));
    if (response.statusCode == 200) {
      setState(() {
        files = List<String>.from(json.decode(response.body));
      });
    }
  }

  Future<void> downloadFile(String filename) async {
    // 폴더 선택 다이얼로그를 열고 경로를 가져옵니다.
    String? directoryPath = await getDirectoryPath();
    if (directoryPath == null || directoryPath.isEmpty) {
      setState(() {
        isDownloading = false;
      });
      return;
    }

    Dio dio = Dio();
    String filePath = '$directoryPath/$filename';
    try {
      setState(() {
        isDownloading = true;
      });
      await dio.download(
        'http://127.0.0.1:8000/api/media/apk/$filename',
        filePath,
      );
      setState(() {
        isDownloading = false;
      });

      // 파일 다운로드 후 실행
      await OpenFile.open(filePath);
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      print(e);
    }
  }

  Future<String?> getDirectoryPath() async {
    try {
      String? directoryPath = await FilePicker.platform.getDirectoryPath();
      if (directoryPath != null) {
        return directoryPath;
      }
    } catch (e) {
      print(e);
    }
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Files'),
      ),
      body: isDownloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(files[index]),
                  onTap: () {
                    downloadFile(files[index]);
                  },
                );
              },
            ),
    );
  }
}
