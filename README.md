# [super_printer](https://pub.dev/packages/super_printer/install)

Amazing plugin helps you to print any receipt you want with (HPRT/APEX) printers , uses native code to implement that.

Using super_printer -> high quality app

**Thank you Hussein Ibrahem for your hard efforts.**

[![pub](https://img.shields.io/pub/v/super_printer?color=blue&logo=flutter&logoColor=blue&style=flat-square)](https://pub.dev/packages/super_printer/install)


<div align="center">
<img src="https://github.com/AbdulkarimDeveloper/super_printer/raw/main/screenshots/example1.jpg" width="30%" height="30%" alt="photo1"/>
<img src="https://github.com/AbdulkarimDeveloper/super_printer/raw/main/screenshots/example2.jpg" width="30%" height="30%" alt="photo2"/>
<img src="https://github.com/AbdulkarimDeveloper/super_printer/raw/main/screenshots/example3.jpg" width="30%" height="30%" alt="photo3"/>
</div>


# Features

**Easy**

You can simply download the package and print using one method.

**Configurable Widget**

You can control any part of this widget feed , width , times....



# Installing

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  super_printer: latest_version
```

Then import the package in dart code:

```dart
import 'package:super_printer/super_printer.dart';
```

More details see [pub.dev](https://pub.dev/packages/super_printer/install).


# Setup

You need to configure your android and ios projects first: 

## Android
You need to add those permissions in `android/app/src/main/AndroidManifest.xml`:

```
<uses-permission android:name="android.permission.BLUETOOTH" />  
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />  
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />  
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" /> 
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />  
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"/>
```

then add in the same file this line here :

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools">    <--- this line
```

and: 

```
<application
    ...
    tools:replace="android:icon, android:label"  <--- this line
    ...
```

Also you need to add the following those lines in `android/app/build.gradle`:

```
android {
    defaultConfig {
        ...
        minSdkVersion 22
        multiDexEnabled true
        ...
    }
}
```


## IOS
You need to add those permissions in `ios/Runner/info.plist`: 

```
<key>NSBluetoothAlwaysUsageDescription</key>
<string>To Select desired printer to print a receipt</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>To Select desired printer to print a receipt</string>
```

If you are working on ios simulator , maybe face an error, to fix it just do that in your project:

Open xcode then go to `Build Settings` tab and inside search box tap *arm* you will find `Exclude Architecture` section

then `Debug` -> `any ios simulator SDK` and add this two words `arm7` and `arm64`


> Use this line `WidgetsFlutterBinding.ensureInitialized();` before runApp(...);



# Usage

You can simply use this plugin bt one method :
```
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



//Mac address and name of the printer is added as hard code.
//You can use other packages to get mac address and name of your printer (bluetooth_connector for android , flutter_blue_plus for ios).
//Don't forget to use permission_handler package to ask permission for bluetooth service
//Print a Paper Width 384 (2 in.) , Width 576 (3 in.) , Width 832 (4 in.)
final printer = SuperPrinter();
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
          
```


*Useful packages you can use with our package:*

[screenshot](https://pub.dev/packages/screenshot/)

[permission_handler](https://pub.dev/packages/permission_handler/)

[bluetooth_connector](https://pub.dev/packages/bluetooth_connector)

[flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus/)



# Widget Properties

**data**

*Uint8List*

represent the image that converted to bytes and sent to printer  to print it

**macAddress**

*String*

MAC Address of the printer

**printerName**

*String*

name of the printer

**printerType**

*Enum*

printer type (APEX , HPRT)

**width**

*int*

width of the image

**printingTimes**

*int*

number of times the printing

**timeout**

*int*

the expected time to finish the printing

**feed**

*int*

number of empty lines

**onPrinting**

*Function*

to handle responses from the native code

---