import 'dart:async';
import 'package:cmkorea_erp/api/operation_api.dart';
import 'package:cmkorea_erp/model/operation.dart';
import 'package:cmkorea_erp/screen/operationRequest/create_operatin_screen.dart';
import 'package:cmkorea_erp/screen/operationRequest/update_operatin_screen.dart';
import 'package:cmkorea_erp/widget/search_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

// ignore: must_be_immutable
class OperationRequestListScreen extends StatefulWidget {
  String place;
  OperationRequestListScreen({super.key, required this.place});

  @override
  OperationRequestListScreenState createState() =>
      OperationRequestListScreenState();
}

class OperationRequestListScreenState
    extends State<OperationRequestListScreen> {
  TextEditingController controller = TextEditingController();

  static List<Operation> _operation = [];
  String query = '';
  Timer? debouncer;
  bool status = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future init() async {
    setState(() => status = true);
    _operation.clear();
    var response = await OperationApi.operationListSearch(query);
    setState(() {
      _operation = response
          .where((element) =>
              element.place == widget.place && element.state != '완료')
          .toList();
    });
    setState(() => status = false);
    const Duration(milliseconds: 200);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('요청 목록'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.to(CreateOperationScreen(
                place: widget.place,
              ))?.then((value) {
                setState(() {
                  init();
                });
              });
            },
            icon: const Icon(Icons.add),
          ),
          actions: [
            IconButton(
              onPressed: () {
                init();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            init();
          },
          child: Column(
            children: <Widget>[
              buildSearch(),
              Expanded(
                child: status
                    ? const Center(
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          backgroundColor: Colors.white,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _operation.length,
                        itemBuilder: (context, index) {
                          final operation = _operation[index];

                          return buildOperation(operation, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search',
        onChanged: searchOperation,
      );

  Future searchOperation(String query) async => debounce(() async {
        var response = await OperationApi.operationListSearch(query);
        if (!mounted) return;
        setState(() {
          this.query = query;
          _operation = response
              .where((element) =>
                  element.place == widget.place && element.state != '완료')
              .toList();
        });
      });

  Widget buildOperation(Operation operation, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Text("${index + 1}"),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(operation.note)),
                Text(operation.state),
              ],
            ),
            subtitle: Text(
              '담당자 : ${operation.completer}',
            ),
            onTap: () {
              Get.to(() => UpdateOperationScreen(operation: operation))
                  ?.then((value) {
                setState(() {
                  init();
                });
              });
            },
          ),
          const Divider(),
        ],
      );
}
