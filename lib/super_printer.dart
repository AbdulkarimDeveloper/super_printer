/* Imports */

import 'dart:typed_data';

import 'package:super_printer/printer_type.dart';
import 'package:super_printer/printing_status.dart';

import 'super_printer_platform_interface.dart';

/* Main Class */

///SuperPrinter package to print a receipt by (APEX/HPRT) printers
class SuperPrinter {
  /* Methods */

  ///Connect to (APEX/HPRT) printer and print the desired receipt
  ///
  ///Parameters
  ///
  ///[data] represent the image that converted to bytes and sent to printer  to print it
  ///
  ///[macAddress] MAC Address of the printer
  ///
  ///[printerName] name of the printer
  ///
  ///[printerType] printer type (APEX , HPRT)
  ///
  ///[width] width of the image
  ///
  ///[printingTimes] number of times the printing
  ///
  ///[timeout] the expected time to finish the printing
  ///
  ///[feed] number of empty lines
  ///
  ///[onPrinting] to handle responses from the native code
  Future<bool> startPrinting(
      {required Uint8List data,
      required String macAddress,
      required String printerName,
      required PrinterType printerType,
      required int width,
      int printingTimes = 1,
      int timeout = 120,
      int? feed,
      Future<void> Function(PrintingStatus result)? onPrinting}) {
    return SuperPrinterPlatform.instance.startPrinting(
        data: data,
        macAddress: macAddress,
        printerName: printerName,
        printerType: printerType,
        width: width,
        feed: feed,
        onPrinting: onPrinting,
        printingTimes: printingTimes,
        timeout: timeout);
  }
}
