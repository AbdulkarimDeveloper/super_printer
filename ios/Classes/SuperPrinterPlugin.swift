import Flutter
import UIKit
import PrinterSDK

public class SuperPrinterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // let channel = FlutterMethodChannel(name: "super_printer", binaryMessenger: registrar.messenger())
    let channel = FlutterMethodChannel(name: "com.aljazary.super_printer/PrintPlugin", binaryMessenger: registrar.messenger())
    let instance = SuperPrinterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    PTDispatcher.share().initBleCentral()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // switch call.method {
    // case "getPlatformVersion":
    //   result("iOS " + UIDevice.current.systemVersion)
    // default:
    //   result(FlutterMethodNotImplemented)
    // }
    
    if call.method == "printImage" {
         self.receiveBatteryLevel(result: result, call: call)
       } else {
         result(FlutterMethodNotImplemented)
         return
       }
  }

  private func receiveBatteryLevel(result: @escaping FlutterResult, call:  FlutterMethodCall) {
    var args = [String: Any]()

      let tempFlutterResult:FlutterResult = result;
    guard let arguments = call.arguments else {
             return
           }
    let myresult = arguments as! [String: Any]
      print(myresult["width"])

    let name = myresult["name"] as!String
      let widthInt: Int = Int(String(describing:myresult["width"]!))!
      let feed: Int = Int(String(describing:myresult["feed"]!))!

      
   //   let width:CGFloat =CGFloat(truncating: NumberFormatter().number(from: myresult["width"] as!String)!)!
     
      
   let width = CGFloat(widthInt)

   print( myresult["bytes"] )
   let data: FlutterStandardTypedData = myresult["bytes"] as! FlutterStandardTypedData
   let uiImage = UIImage(data: data.data)!
           guard let zybImage = PDResetImage.scaleImageForWidth(image: uiImage, width: width) else { return }

   var dataSources = [PTPrinter]()
   var errorStr: String?
   print("PTDispatcher.share().printerConnected  \(PTDispatcher.share().printerConnected)"  )
   if PTDispatcher.share().printerConnected == nil {
    dataSources.removeAll()
     print(name)
    PTDispatcher.share().scanBluetooth()
    PTDispatcher.share()?.whenFindAllBluetooth({ [weak self] in
      guard let temp = $0 as? [PTPrinter] else { return }
      print(temp.capacity)
      print(temp[0].ip)
      print(temp[0].mac)
      print(temp[0].port)
      print(temp[0].name)
      dataSources = temp.sorted(by: { (pt1, pt2) -> Bool in
        print(pt1.mac)
        print(pt1)
      return pt1.distance.floatValue < pt2.distance.floatValue
     })
             if let printer:PTPrinter = dataSources.first(where: { $0.name == name }) {
                print("Found at ")
                 PTDispatcher.share().connect(printer)
              //   PTDispatcher.share().connect(dataSources[0])
             } else {
                print("Not found")
                  args["status"] = false
      args["message"] = "printer not found"
           result(args)
              }
    
      
    })

   }
   PTDispatcher.share().whenConnectSuccess { [weak self] in
    print("whenConnectSuccess")
     var cmdData = Data()
     let cmd = PTCommandESC.init()
    cmd.setPrintAreaWidth(widthInt)
     cmd.initializePrinter()
     cmd.appendRasterImage(
      zybImage.cgImage, mode: PTBitmapMode.dithering, compress: .LZO, package: false)
                cmd.printAndFeedLines(feed)

     cmdData.append(cmd.getCommandData())
      PTDispatcher.share()?.send(cmdData)
   }
     var cmdData = Data()
     let cmd = PTCommandESC.init()
     cmd.setPrintAreaWidth(widthInt)
     cmd.initializePrinter()
     cmd.appendRasterImage(
      zybImage.cgImage, mode: PTBitmapMode.dithering, compress: .LZO, package: false)
          cmd.printAndFeedLines(feed)

     cmdData.append(cmd.getCommandData())

      PTDispatcher.share()?.send(cmdData)
   PTDispatcher.share().whenConnectFailureWithErrorBlock { (error) in
    switch error {
    case .bleTimeout:
     errorStr = "Connection timeout"
    case .bleValidateTimeout:
     errorStr = "Vertification timeout"
    case .bleUnknownDevice:
     errorStr = "Unknown device"
    case .bleSystem:
     errorStr = "System error"
    case .bleValidateFail:
     errorStr = "Vertification failed"
    case .bleDisvocerServiceTimeout:
     errorStr = "Connection failed"
    default:
     break
    }

    args["status"] = false
    args["message"] = errorStr
       result(FlutterError(code: "Faield", message: "Error.",details:args))
    if let temp = errorStr {
     print("temp" + temp)
    }
   }
   //Sent successfully
    PTDispatcher.share().whenSendSuccess ({(_,_) in
       print("whenSendSuccess")
        args["status"] = true
      args["message"] = "done"
           result(args)
    })
   // Sending failed
   PTDispatcher.share().whenSendFailure { [weak self] in
    print("whenSendFailure")
    args["status"] = false
    args["message"] = "error"
       result(FlutterError(code: "Faield", message: "Error.",details:args))

  
   }
   // Receive data returned by Bluetooth
   PTDispatcher.share().whenReceiveData { (temp) in
    print("whenReceiveData")
   }
   /// POS ESC command support
   PTDispatcher.share().whenESCPrintSuccess { _ in
    print("whenESCPrintSuccess")
    args["status"] = true
  args["message"] = "done"
       result(args)
   }
  }
}


class PDResetImage: NSObject {
    static func scaleSourceImage(image:UIImage, width:CGFloat, height:CGFloat) -> UIImage? {
        let drawWidth = CGFloat(ceil(width))
        let drawHeight = CGFloat(ceil(height))
        let size = CGSize(width: drawWidth, height: drawHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        image.draw(in: CGRect.init(x: 0, y: 0, width: drawWidth, height: drawHeight))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImage
    }
    static func scaleImageForWidth(image:UIImage, width:CGFloat) -> UIImage? {
        let imageW = image.size.width
        let imageH = image.size.height
        var maxH : CGFloat = 0
//        if imageW > width {
//
//        }else {
//            return image
//        }
        
        maxH = CGFloat(Int(width * imageH / imageW))
        return self.scaleSourceImage(image: image, width: width, height: maxH)
    }
}