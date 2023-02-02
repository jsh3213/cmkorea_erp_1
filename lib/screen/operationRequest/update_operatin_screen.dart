import 'package:cmkorea_erp/api/operation_api.dart';
import 'package:cmkorea_erp/controller/getxController.dart';
import 'package:cmkorea_erp/model/operation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// ignore: must_be_immutable
class UpdateOperationScreen extends StatefulWidget {
  Operation operation;

  UpdateOperationScreen({Key? key, required this.operation}) : super(key: key);

  @override
  State<UpdateOperationScreen> createState() => _UpdateOperationScreenState();
}

class _UpdateOperationScreenState extends State<UpdateOperationScreen> {
  @override
  void initState() {
    _operation = widget.operation;
    _state = widget.operation.state;
    _place = widget.operation.place;
    controllerPlace.text = widget.operation.place;
    controllerNote.text = widget.operation.note;
    controllerStateNote.text = widget.operation.stateNote;
    controllerRequester.text = widget.operation.requester;
    controllerCompleter.text = widget.operation.completer;
    _doneDate = widget.operation.doneDate;
    super.initState();
  }

  TextEditingController controllerText = TextEditingController();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
      } else if (args.value is DateTime) {
        setState(() {
          _doneDate = DateFormat('yyyy-MM-dd').format(args.value);
        });
      } else if (args.value is List<DateTime>) {
        // _dateCount = args.value.length.toString();
      } else {
        // _rangeCount = args.value.length.toString();
      }
    });
  }

  TextEditingController controllerState = TextEditingController();
  TextEditingController controllerPlace = TextEditingController();
  TextEditingController controllerNote = TextEditingController();
  TextEditingController controllerStateNote = TextEditingController();
  TextEditingController controllerRequester = TextEditingController();
  TextEditingController controllerCompleter = TextEditingController();
  TextEditingController controllerDoneDate = TextEditingController();

  String _doneDate = '';
  late Operation _operation;
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
          widget.operation.place,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => {
              operationUpdate(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('작성일 : '),
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(widget.operation.created)),
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.operation.doneDate == ''
                            ? Container()
                            : const Text('완료일 : '),
                        Text(
                          widget.operation.doneDate,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    buildText('상태 : ', _state, _list),
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
                        const SizedBox(height: 10),
                        buildNoteTextField('진행 상황 : ', controllerStateNote),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                '완료일 : ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Text(_doneDate),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlueAccent),
                                child: const Text(
                                  '선택',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'S/N: ${widget.operation.state}',
                              // titleStyle: TextStyle(fontSize: 15),
                              content: TextField(
                                controller: controllerText,
                                decoration: const InputDecoration(
                                    labelText: "cmk 입력하세요."),
                                textInputAction: TextInputAction.done,
                              ),
                              confirmTextColor: Colors.white,
                              textCancel: "취소",
                              textConfirm: "삭제",
                              onConfirm: () async {
                                if (controllerText.text == 'cmk') {
                                  int a = await OperationApi.operationDelete(
                                      _operation.id);
                                  if (a == 200) {
                                    Get.back();
                                    Get.back();
                                    controllerText.text = "";
                                    Get.snackbar('삭제', '',
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                } else {
                                  controllerText.text = "";
                                  Get.back();
                                  Get.snackbar('실패', '',
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              },
                              onCancel: () {
                                controllerText.text = "";
                                Get.back();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          child: const Text(
                            '삭제',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
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
            flex: 5,
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
        flex: 5,
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
        flex: 5,
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

  _selectDate(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("달력"),
      actions: [
        okButton,
      ],
      content: SizedBox(
        width: 300,
        height: 300,
        child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedRange: PickerDateRange(
              DateTime.now().subtract(const Duration(days: 4)),
              DateTime.now().add(const Duration(days: 3))),
        ),
      ),
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void operationUpdate() async {
    setState(() => wait = true);
    int status = await OperationApi.operationUpdate(
      widget.operation.id,
      _place,
      _state,
      controllerRequester.text,
      controllerNote.text,
      controllerCompleter.text,
      controllerStateNote.text,
      _doneDate,
    );
    if (status == 200) {
      Get.back();
      Get.snackbar('성공', '저장 완료 ', snackPosition: SnackPosition.BOTTOM);
    }
    setState(() => wait = false);
  }
}
