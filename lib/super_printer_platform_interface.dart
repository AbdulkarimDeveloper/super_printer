/* Imports */

import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:super_printer/printer_type.dart';
import 'package:super_printer/printing_status.dart';

import 'super_printer_method_channel.dart';

abstract class SuperPrinterPlatform extends PlatformInterface {
  /// Constructs a SuperPrinterPlatform.
  SuperPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SuperPrinterPlatform _instance = MethodChannelSuperPrinter();

  /// The default instance of [SuperPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSuperPrinter].
  static SuperPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SuperPrinterPlatform] when
  /// they register themselves.
  static set instance(SuperPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Future<String?> getPlatformVersion() {
  //   throw UnimplementedError('platformVersion() has not been implemented.');
  // }

  ///Printing Abstraction
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
    throw UnimplementedError('startPrinting() has not been implemented.');
  }
}
