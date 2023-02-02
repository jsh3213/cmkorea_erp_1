import 'package:cmkorea_erp/api/operation_api.dart';
import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:cmkorea_erp/model/operation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

// ignore: must_be_immutable
class CreateOperationScreen extends StatefulWidget {
  String place;

  CreateOperationScreen({Key? key, required this.place}) : super(key: key);

  @override
  State<CreateOperationScreen> createState() => _CreateOperationScreenState();
}

class _CreateOperationScreenState extends State<CreateOperationScreen> {
  @override
  void initState() {
    _place = widget.place;
    super.initState();
  }

  TextEditingController controllerText = TextEditingController();

  TextEditingController controllerState = TextEditingController();
  TextEditingController controllerRequester = TextEditingController();
  TextEditingController controllerNote = TextEditingController();
  TextEditingController controllerCompleter = TextEditingController();

  String _state = '요청';
  String _place = '';

  bool wait = false;
  final controller = Get.put(ReactiveController());

  final List<String> _list = [
    '요청',
    '대기',
    '진행 중',
    '완료',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.place,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => {createOperation()},
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
      body: wait
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildText('상태 : ', _state, _list),
                    const Divider(),
                    Column(children: [
                      buildTextField('작성자 : ', controllerRequester),
                      const SizedBox(height: 10),
                      buildNoteTextField('요청 사항 : ', controllerNote),
                    ]),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        buildTextField('담당자 : ', controllerCompleter),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
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
                            fontSize: 18,
                            color: Colors.blueAccent,
                          )),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _state = value.toString();
                    });
                  }),
            ])),
      ],
    );
  }

  buildTextField(String text, TextEditingController controller) {
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
            textInputAction: TextInputAction.next,
            maxLines: 1,
          ),
        ),
      ),
    ]);
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
            maxLines: 7,
          ),
        ),
      ),
    ]);
  }

  void createOperation() async {
    setState(() => wait = true);
    int status = await OperationApi.operationCreate(
      _place,
      _state,
      controllerRequester.text,
      controllerNote.text,
      controllerCompleter.text,
    );
    if (status == 200) {
      Get.back();
      Get.snackbar('성공', '생성 완료 ', snackPosition: SnackPosition.BOTTOM);
    }
    setState(() => wait = false);
  }
}
