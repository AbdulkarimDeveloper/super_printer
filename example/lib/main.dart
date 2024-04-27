import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:super_printer/printer_type.dart';
import 'package:super_printer/printing_status.dart';
import 'package:super_printer/super_printer.dart';
import 'package:super_printer_example/print_order.dart';

void main() {
  //Ensure platform channels are established correctly.
  WidgetsFlutterBinding.ensureInitialized();
  //Run th app
  runApp(const App());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Super Printer',
        navigatorKey: navigatorKey,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.1)),
              child: child!);
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const PrinterScreen());
  }
}

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key});

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  var controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Super Printer"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [PrintOrderWidget(screenshotController: controller)],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Convert the widget you want to print to bytes by screenshot package
          Uint8List data = await controller.captureFromWidget(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Directionality(
                      textDirection:
                          Directionality.of(navigatorKey.currentContext!),
                      child:
                          const PrintOrderWidget(screenshotController: null)),
                ],
              ),
              pixelRatio:
                  MediaQuery.of(navigatorKey.currentContext!).devicePixelRatio,
              delay: const Duration(milliseconds: 1000),
              context: navigatorKey.currentContext!);

          //Init printer object
          final printer = SuperPrinter();
          //Mac address and name of the printer is added as hard code.
          //You can use other packages to get mac address and name of your printer (bluetooth_connector for android , flutter_blue_plus for ios).
          //Don't forget to use permission_handler package to ask permission for bluetooth service
          //Print a Paper Width 384 (2 in.) , Width 576 (3 in.) , Width 832 (4 in.)
          printer.startPrinting(
              data: data,
              macAddress: '00:12:F3:19:26:A2',
              printerName: 'APEX3',
              printerType: PrinterType.apex,
              width: 576,
              feed: 2,
              printingTimes: 1,
              timeout: 120,
              onPrinting: _onPrintingResponse);
        },
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
    );
  }

  ///Handle response from the package
  Future<void> _onPrintingResponse(PrintingStatus result) async {
    switch (result) {
      case PrintingStatus.printing:
        {
          log('printing.....');
        }
      case PrintingStatus.failedPrint:
        {
          log('Printing is failed printing');
        }
      case PrintingStatus.platformException:
        {
          log('Printing causes platform exception');
        }
      case PrintingStatus.exception:
        {
          log('Printing causes an exception');
        }
      case PrintingStatus.success:
        {
          log('Printing is successful');
        }
      default:
        {
          log('not found');
        }
    }
  }
}
