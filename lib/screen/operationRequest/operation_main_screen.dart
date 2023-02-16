import 'package:cmkorea_erp/screen/operationRequest/list_complete_screen.dart';
import 'package:cmkorea_erp/screen/operationRequest/list_operation_screen.dart';
import 'package:flutter/material.dart';
import '../../model/product.dart';

class OperationMainScreen extends StatefulWidget {
  const OperationMainScreen({super.key});

  @override
  State<OperationMainScreen> createState() => _OperationMainScreenState();
}

class _OperationMainScreenState extends State<OperationMainScreen> {
  List<Product> products = [];
  final List _tabList = ['103호', '104호', '108호', '109호', '구매 요청'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabList.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 70),
              TabBar(
                labelStyle: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontSize: 15.0),
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: List.generate(
                  _tabList.length,
                  (int index) {
                    return Tab(
                      text: _tabList[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    buildView('103호'),
                    buildView('104호'),
                    buildView('108호'),
                    buildView('109호'),
                    buildView('구매 요청'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildView(String _) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            child: OperationRequestListScreen(place: _),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(5),
            ),
            child: OperationCompleteListScreen(place: _),
          ),
        ),
      ],
    );
  }
}
