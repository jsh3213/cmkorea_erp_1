import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../model/product.dart';
import '../controller/getxController.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

class ProductApi {
  static Future<List<Product>> productListSearch(String query) async {
    final url = Uri.parse('$baseUrl/api/product/repairTypeList/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List products = json.decode(utf8.decode(response.bodyBytes));
      return products.map((json) => Product.fromJson(json)).where((product) {
        final serialLower = product.serialNumber.toLowerCase();
        final modelLower = product.model.toLowerCase();
        final searchLower = query.toLowerCase();
        return serialLower.contains(searchLower) ||
            modelLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<Product>> productList() async {
    final url = Uri.parse("$baseUrl/api/product/repairTypeList/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List products = json.decode(utf8.decode(response.bodyBytes));
      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future<Product> productDetail(int id) async {
    final url = Uri.parse('$baseUrl/api/product/detail/$id/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final value = json.decode(utf8.decode(response.bodyBytes));
      var product = Product.fromJson(value);
      return product;
    } else {
      throw Exception();
    }
  }

  static Future productUpdate(
    int id,
    String repairTypeDecide,
    String note,
  ) async {
    int statusCode = 0;
    await http.post(Uri.parse('$baseUrl/api/product/update/$id/'), body: {
      'repairTypeDecide': repairTypeDecide,
      'note': note,
    }).then((value) => statusCode = value.statusCode);
    return statusCode;
  }
}
