import 'package:cmkorea_erp/model/product.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DataScreen extends StatefulWidget {
  Product product;

  DataScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  DataScreenState createState() => DataScreenState();
}

class DataScreenState extends State<DataScreen> {
  bool wait = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                  child: wait
                      ? const Center(
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                            backgroundColor: Colors.white,
                          ),
                        )
                      : buildView()),
            ),
          ],
        ),
      ),
    );
  }

  Column buildView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildData(),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildData() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDataTable(),
          const SizedBox(height: 20),
          const Text('Note'),
          buildNoteText(widget.product.note),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildDataTable() {
    return Table(border: TableBorder.all(), children: [
      TableRow(children: [
        buildText('Model : ', widget.product.model),
      ]),
      TableRow(children: [
        buildText('S/N : ', widget.product.serialNumber),
      ]),
      TableRow(children: [
        buildText('규격 : ', widget.product.standard),
      ]),
    ]);
  }

  Row buildText(String text, String widget) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
          height: 30,
        ),
        Expanded(
          flex: 1,
          child: Text(text,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 2,
          child: Text(widget, textAlign: TextAlign.start),
        )
      ],
    );
  }

  Row buildNoteText(String widget) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text(
              widget,
              textAlign: TextAlign.start,
              maxLines: 5,
            ),
          ),
        )
      ],
    );
  }
}
