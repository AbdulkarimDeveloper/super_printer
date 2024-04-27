/* Imports */

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:super_printer/printer_type.dart';
import 'package:super_printer/printing_status.dart';

import 'super_printer_platform_interface.dart';

/// An implementation of [SuperPrinterPlatform] that uses method channels.
class MethodChannelSuperPrinter extends SuperPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('super_printer');

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
  //   return version;
  // }

  ///Printing implementation
  @override
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
    return PrintHelper.startPrint(
      data: data,
      macAddress: macAddress,
      printerName: printerName,
      printerType: printerType,
      width: width,
      feed: feed,
      onPrinting: onPrinting,
      printingTimes: printingTimes,
      timeout: timeout,
    );
  }
}

///Printer code
class PrintHelper {
  static MethodChannel platform =
      const MethodChannel('com.aljazary.super_printer/PrintPlugin');
  static Future<bool> startPrint(
      {required Uint8List data,
      required String macAddress,
      required String printerName,
      required PrinterType printerType,
      required int width,
      int printingTimes = 1,
      int timeout = 120,
      int? feed,
      Future<void> Function(PrintingStatus result)? onPrinting}) async {
    try {
      log("printing times:  $printingTimes ");
      for (var i = 0; i < printingTimes; i++) {
        dynamic result =
            await platform.invokeMethod('printImage', <String, dynamic>{
          'bytes': data,
          'macAddress': macAddress,
          'feed': feed ?? 2,
          'name': printerName,
          'printerType': printerType.name,
          'width': width
        }).timeout(Duration(seconds: timeout));
        _parseResult(result: result, onPrinting: onPrinting);
        await Future.delayed(const Duration(seconds: 2));
      }

      if (onPrinting != null) {
        await onPrinting(PrintingStatus.success);
      }
      return true;
    } on PlatformException catch (e) {
      log("Printing PlatformException: ${e.toString()}");
      if (onPrinting != null) {
        await onPrinting(PrintingStatus.platformException);
      }
      return false;
    } on Exception catch (e) {
      log("Printing Exception: ${e.toString()}");
      if (onPrinting != null) {
        await onPrinting(PrintingStatus.exception);
      }
      return false;
    }
  }

  ///Parse response from android/ios native code
  static Future<void> _parseResult(
      {required dynamic result,
      String? def = "pleaseSelectPrinterAndTryAgain",
      required Future<void> Function(PrintingStatus result)?
          onPrinting}) async {
    try {
      final resultMap = result is Map<Object?, Object?>
          ? result
          : json.decode(result) as Map<String, dynamic>;
      log("printing status: ${(resultMap["status"] == true).toString()}");
      if (resultMap["status"] == true) {
        log('printing status: Printing');
        if (onPrinting != null) {
          await onPrinting(PrintingStatus.printing);
        }
      } else {
        log('printing status: Failed \n${resultMap['message']} \n$def');
        if (onPrinting != null) {
          await onPrinting(PrintingStatus.failedPrint);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
