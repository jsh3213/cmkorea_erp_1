import 'package:cmkorea_erp/main.dart';
import 'package:flutter/material.dart';
import '../api/product_api.dart';
import '../controller/getxController.dart';
import '../model/product.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

// ignore: must_be_immutable
class UpdateScreen extends StatefulWidget {
  Product product;

  UpdateScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpDateScreenState();
}

class _UpDateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    _selecteValue = widget.product.repairTypeDecide;
    controllerNote.text = widget.product.note;
    super.initState();
  }

  TextEditingController controllerNote = TextEditingController();
  String _selecteValue = '확인';
  bool wait = false;
  final controller = Get.put(ReactiveController());

  final List<String> _list = [
    '확인',
    '대기',
    '현업 대기',
    '완료',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.product.serialNumber,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => {
              productUpdate(),
            },
            child: const Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all()),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildText('수리타입 결정 : ', _selecteValue, _list),
                const Divider(),
                buildNoteTextField('주의사항 : ', controllerNote),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildText(String title, String value, List valueList) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            )),
        Expanded(
            flex: 3,
            child: Row(children: [
              DropdownButton(
                  value: value,
                  items: valueList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selecteValue = value.toString();
                    });
                  }),
            ])),
      ],
    );
  }

  buildNoteTextField(String text, TextEditingController controller) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )),
      Expanded(
        flex: 3,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: TextField(
            style: Theme.of(context).textTheme.titleLarge,
            controller: controller,
            textInputAction: TextInputAction.done,
            maxLines: 5,
          ),
        ),
      ),
    ]);
  }

  void productUpdate() async {
    setState(() => wait = true);
    int status = await ProductApi.productUpdate(
      widget.product.id,
      _selecteValue,
      controllerNote.text,
    );
    if (status == 200) {
      Get.off(const MyHomePage());
      Get.snackbar('성공', '저장 완료 ', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
