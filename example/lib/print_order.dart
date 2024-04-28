import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class PrintOrderWidget extends StatefulWidget {
  final ScreenshotController? screenshotController;
  const PrintOrderWidget({super.key, this.screenshotController});

  @override
  State<PrintOrderWidget> createState() => _PrintOrderWidgetState();
}

class _PrintOrderWidgetState extends State<PrintOrderWidget> {
  _PrintOrderWidgetState();

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
        color: Colors.black,
        height: 1.3,
        fontSize: 10,
        fontWeight: FontWeight.bold);
    const diver = SizedBox(height: 5);

    var consumer = Container(
      // key: key,
      color: Colors.white,
      width: 200,
      // width: tt.printSetting.width,
      child: Column(
        children: [
          PrintHeader(
            style: style,
          ),
          diver,
          Text('NOTE', style: style),
          diver,
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
            },
            children: [
              buildTowRows('PartyName', ": 1234", style),
              buildTowRows('waiter', ": user1", style),
              buildTowRows('date', ": 22-03-2023", style),
              buildTowRows('Total', ": 30\$", style),
              buildTowRows('Discount', ": 5\$", style),
              buildTowRows('Net Total', ": 25\$", style),
              buildTowRows('Print-Date:', ": 22-03-2023", style),
            ],
          ),
          diver,
          Table(
            border: TableBorder.all(borderRadius: BorderRadius.circular(3)),
            columnWidths: const {
              0: FlexColumnWidth(5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
            },
            children: [
              buildHeader(style),
              buildRows(style.copyWith(fontSize: 10))
              // ...widget.model.sellOrders
              //     .mapIndexed<TableRow>((index, e) => buildRows(
              //         e,
              //         style.copyWith(fontSize: tt.printSetting.tableFontSize),
              //         index))
              //     .toList()
            ],
          ),
          diver,
          // SignatureWidgetChild(
          //     text: widget.textEditingController.text, style: style),
        ],
      ),
    );

    if (widget.screenshotController == null) {
      return consumer;
    }
    return Screenshot(
      controller: widget.screenshotController!,
      child: consumer,
    );
  }

  TableRow buildTowRows(String str1, String str2, TextStyle style,
      {double padding = 1}) {
    return TableRow(children: [
      Padding(
          padding: EdgeInsets.all(padding), child: Text(str1, style: style)),
      Padding(
          padding: EdgeInsets.all(padding), child: Text(str2, style: style)),
    ]);
  }

  TableRow buildRows(TextStyle style) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(1),
        child: Center(child: Text('product1', style: style)),
      ),
      Padding(
        padding: const EdgeInsets.all(1),
        child: Center(child: Text('30', style: style)),
      ),
      Padding(
        padding: const EdgeInsets.all(1),
        child: Center(child: Text('1', style: style)),
      ),
      Padding(
        padding: const EdgeInsets.all(1),
        child: Center(child: Text('30', style: style)),
      ),
      Padding(
        padding: const EdgeInsets.all(1),
        child: Center(child: Text('30', style: style)),
      ),
    ]);
  }

  TableRow buildHeader(TextStyle style) {
    return TableRow(children: [
      // Padding(
      //     padding: const EdgeInsets.all(1),
      //     child: Center(child: Text("#", style: style))),
      Padding(
          padding: const EdgeInsets.all(1),
          child: Center(child: Text('name', style: style))),
      Padding(
        padding: const EdgeInsets.all(1),
        child: Center(child: Text('uom', style: style)),
      ),
      Padding(
          padding: const EdgeInsets.all(1),
          child: Center(child: Text('qty', style: style))),
      Padding(
        padding: const EdgeInsets.all(1),
        child: Center(child: Text('price', style: style)),
      ),
      Padding(
          padding: const EdgeInsets.all(1),
          child: Center(child: Text('total', style: style)))
    ]);
  }
}

class PrintHeader extends StatelessWidget {
  const PrintHeader({super.key, required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        width: 200, //sl<PrintSettingNotifer>().printSetting.width
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3), border: Border.all()),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Al-Jazary', //companyName
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: style),
                  Text('Erbil', //accountAddress
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: style),
                  Text('+964751069448', //accountPhone
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: style),
                ],
              ),
            ),
            Image.asset(
              'assets/aljazary_logo_black.png',
              width: 75,
              height: 75,
            )
          ],
        ),
      );
    });
  }
}
