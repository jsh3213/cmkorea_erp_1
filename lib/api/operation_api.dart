import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:cmkorea_erp/model/operation.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../controller/getxController.dart';

final controller = Get.put(ReactiveController());
final baseUrl = controller.baseUrl;

class OperationApi {
  static Future<List<Operation>> operationListSearch(String query) async {
    final url = Uri.parse('$baseUrl/api/operation/list/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List operations = json.decode(utf8.decode(response.bodyBytes));
      return operations.map((json) => Operation.fromJson(json)).where((_) {
        final noteLower = _.note.toLowerCase();
        final searchLower = query.toLowerCase();
        return noteLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<Operation> operationDetail(int id) async {
    final url = Uri.parse('$baseUrl/api/operation/detail/$id/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final value = json.decode(utf8.decode(response.bodyBytes));
      var operation = Operation.fromJson(value);
      return operation;
    } else {
      throw Exception();
    }
  }

  static Future operationCreate(
    String place,
    String state,
    String requester,
    String note,
    String completer,
  ) async {
    int statusCode = 0;
    final url = Uri.parse('$baseUrl/api/operation/create/');
    await http.post(url, body: {
      "place": place,
      "state": state,
      "requester": requester,
      "note": note,
      "completer": completer,
    }).then((value) {
      statusCode = value.statusCode;
    });
    return statusCode;
  }

  static Future operationUpdate(
    int id,
    String place,
    String state,
    String requester,
    String note,
    String completer,
    String stateNote,
    String doneDate,
  ) async {
    int statusCode = 0;
    await http.post(Uri.parse('$baseUrl/api/operation/update/$id/'), body: {
      "place": place,
      'state': state,
      'requester': requester,
      "note": note,
      'completer': completer,
      "stateNote": stateNote,
      'doneDate': doneDate,
    }).then((value) => statusCode = value.statusCode);
    return statusCode;
  }

  static Future operationDelete(int id) async {
    await http.delete(Uri.parse("$baseUrl/api/operation/delete/$id/"));
    return 200;
  }
}
