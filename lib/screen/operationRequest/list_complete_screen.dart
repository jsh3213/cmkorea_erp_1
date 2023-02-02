import 'dart:async';
import 'package:cmkorea_erp/api/operation_api.dart';
import 'package:cmkorea_erp/model/operation.dart';
import 'package:cmkorea_erp/screen/operationRequest/update_operatin_screen.dart';
import 'package:cmkorea_erp/widget/search_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

// ignore: must_be_immutable
class OperationCompleteListScreen extends StatefulWidget {
  String place;
  OperationCompleteListScreen({super.key, required this.place});

  @override
  OperationCompleteListScreenState createState() =>
      OperationCompleteListScreenState();
}

class OperationCompleteListScreenState
    extends State<OperationCompleteListScreen> {
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
    var response = await OperationApi.operationListSearch(query);
    setState(() => _operation = response
        .where((_) => _.place == widget.place && _.state == '완료')
        .toList());
    setState(() => status = false);
    const Duration(milliseconds: 200);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('완료 목록'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  init();
                },
                icon: const Icon(Icons.refresh))
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
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
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
        onChanged: searchProducts,
      );

  Future searchProducts(String query) async => debounce(() async {
        var response = await OperationApi.operationListSearch(query);
        if (!mounted) return;
        setState(() {
          this.query = query;
          _operation = response
              .where((element) =>
                  element.place == widget.place && element.state == '완료')
              .toList();
        });
      });

  Widget buildOperation(Operation operation, index) => ListTile(
        leading: Text("${index + 1}"),
        title: Row(
          children: [
            Text(
              operation.note,
            ),
            const SizedBox(width: 10),
          ],
        ),
        subtitle: Text(
          operation.state,
        ),
        onTap: () {
          Get.to(() => UpdateOperationScreen(operation: operation))
              ?.then((value) {
            setState(() {
              init();
            });
          });
        },
      );
}
