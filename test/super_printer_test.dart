import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:super_printer/printer_type.dart';
import 'package:super_printer/printing_status.dart';
import 'package:super_printer/super_printer_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSuperPrinterPlatform
    with MockPlatformInterfaceMixin
    implements SuperPrinterPlatform {
  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');

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
    return Future.value(true);
  }
}

void main() {
  // final SuperPrinterPlatform initialPlatform = SuperPrinterPlatform.instance;

  // test('$MethodChannelSuperPrinter is the default instance', () {
  //   expect(initialPlatform, isInstanceOf<MethodChannelSuperPrinter>());
  // });

  // test('getPlatformVersion', () async {
  //   SuperPrinter superPrinterPlugin = SuperPrinter();
  //   MockSuperPrinterPlatform fakePlatform = MockSuperPrinterPlatform();
  //   SuperPrinterPlatform.instance = fakePlatform;

  //   expect(await superPrinterPlugin.getPlatformVersion(), '42');
  // });
}
