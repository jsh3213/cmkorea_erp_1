import 'dart:async';
import 'package:cmkorea_erp/screen/update_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../../model/product.dart';
import '../api/product_api.dart';
// ignore: depend_on_referenced_packages
import 'package:audioplayers/audioplayers.dart';

class ListDoneScreen extends StatefulWidget {
  const ListDoneScreen({super.key});

  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<ListDoneScreen> {
  static List<Product> products = [];
  String query = '';
  bool wait = true;
  bool status = false;
  static Timer? _timer1;
  static Timer? _timer2;
  static Timer? _timer3;
  bool colorChange = false;
  final AudioCache cache = AudioCache();
  final player = AudioPlayer();

  @override
  void initState() {
    init();
    super.initState();
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
  }

  @override
  void didChangeDependencies() {
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

  Future init() async {
    showColor();
  }

  showColor() async {
    setState(() => wait = true);
    var response = await ProductApi.productList();
    setState(() {
      products = response
          .where((element) => element.repairTypeDecide == '완료')
          .toList();
    });
    setState(() {
      wait = false;
    });

    if (controller.settingColor.value == true) {
      _timer1 = Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          colorChange = !colorChange;
        });
        controller.colorChange.value = colorChange;
        if (products.isEmpty) {
          _timer1?.cancel();
          controller.colorChange.value = false;
        }
      });
    }
    if (controller.settingAlarm.value == true) {
      if (controller.settingAlarm.value == true) {
        _timer2 = Timer.periodic(const Duration(seconds: 60), (timer) {
          if (products.isEmpty) {
            _timer2?.cancel();
          } else {
            player.play(AssetSource('dingdong.mp3'));
          }
        });
      }
    }

    _timer3 = Timer.periodic(const Duration(seconds: 60), (timer) {
      getList();
    });
  }

  void getList() async {
    var response = await ProductApi.productList();
    setState(() {
      products = response
          .where((element) => element.repairTypeDecide == '완료')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('수리 타입 결정(완료)  수량: ${products.length}'),
        centerTitle: true,
        leading: Container(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: wait
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                    )
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Column(
                          children: [
                            buildProduct(product, index),
                            const Divider(),
                          ],
                        );
                      },
                    )),
        ],
      ));

  Widget buildProduct(Product product, index) => ListTile(
        leading: Text(
          "${index + 1}",
        ),
        title: Row(
          children: [
            Text(
              product.serialNumber,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.note),
            ),
          ],
        ),
        subtitle: Text(
          product.model,
        ),
        onTap: () {
          Get.to(() => UpdateScreen(
                product: products[index],
              ));
        },
      );
}
