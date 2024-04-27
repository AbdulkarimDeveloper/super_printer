package com.aljazary.super_printer;

import androidx.annotation.NonNull;
import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

/** SuperPrinterPlugin */
public class SuperPrinterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  private static final String CHANNEL = "com.aljazary.super_printer/PrintPlugin";
  PrintMainActivity mMainActivity = new PrintMainActivity();
  HprtPrintPrintMainActivity hprintPrintMainActivity = new HprtPrintPrintMainActivity();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    // channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "super_printer");
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL);
    context = flutterPluginBinding.getApplicationContext();
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("printImage")) {
          String type = call.argument("printerType");
          Log.d("TAG", type);
          if (type.equals("apex")) {
          byte[] bytes = (byte[]) call.argument("bytes");
              mMainActivity.onPrint(bytes, call.argument("macAddress"), call.argument("width"), result, call.argument("feed"), context);
          } else if(type.equals("hprt")) {
          byte[] bytes = (byte[]) call.argument("bytes");
          hprintPrintMainActivity.onPrint(bytes, call.argument("macAddress"), call.argument("width"), result, call.argument("feed"), context);

          }
      }
    // if (call.method.equals("getPlatformVersion")) {
    //   result.success("Android " + android.os.Build.VERSION.RELEASE);
    // } else {
    //   result.notImplemented();
    // }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
