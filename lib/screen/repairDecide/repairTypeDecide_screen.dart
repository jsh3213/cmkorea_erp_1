import 'package:cmkorea_erp/screen/repairDecide/time_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:timer_builder/timer_builder.dart';
import '../../model/product.dart';
import 'list_done_screen.dart';
import 'list_wait_screen.dart';

class RepairTypeDecideScreen extends StatefulWidget {
  const RepairTypeDecideScreen({super.key});

  @override
  State<RepairTypeDecideScreen> createState() => _RepairTypeDecideScreenState();
}

class _RepairTypeDecideScreenState extends State<RepairTypeDecideScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: TimerBuilder.periodic(const Duration(seconds: 5),
              builder: (context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(flex: 1, child: TimeScreen()),
              const Divider(),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.green),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const ListWaitScreen(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const ListDoneScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      })),
    );
  }
}
