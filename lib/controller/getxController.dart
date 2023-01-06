// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../api/product_api.dart';
import '../model/product.dart';
import 'package:http/http.dart' as http;

class BuilderController extends GetxController {
  // String baseUrl = "http://180.69.27.114:8080";
  // String baseUrl = "http://14.47.200.173:8080";
  // String baseUrl = "http://10.0.2.2:8000";
  String baseUrl = "http://127.0.0.1:8000";
  List<Product> products = [];
  int statusCode = 0;

  Future<List<Product>> productList() async {
    final url = Uri.parse("$baseUrl/api/product/list/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List products = json.decode(utf8.decode(response.bodyBytes));
      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  Future<List<Product>> getList() async {
    var response = await productList();
    products = response.where((e) => e.repairTypeDecide == '완료').toList();
    update();
    audioPlay();
    return products;
  }

  audioPlay() {
    if (products.isNotEmpty) {
      final player = AudioCache();
      player.play('dingdong.mp3');
    }
  }
}
