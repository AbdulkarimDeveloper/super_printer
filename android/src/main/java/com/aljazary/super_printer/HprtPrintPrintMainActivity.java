package com.aljazary.super_printer;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import java.util.Locale;
import java.util.Map;
import io.flutter.plugin.common.MethodChannel.Result;
import print.Print;
public class HprtPrintPrintMainActivity {

    //Print Paper Width 384 (2 in.)
    //Print Paper Width 576 (3 in.)
    //Print Paper Width 832 (4 in.)
    //Keys to pass data to Connection Activity
    private final String TAG = "PRINTING";

    //Document and Parameter Objects
    Context context;
    private final int PRINT_THREE_INCH = 576;
    private String bluetoothAddress;

    public void onPrint(byte[] bytesImage, String m_printerMACParam, int width, Result result, int feed, Context context) {
        this.context = context;
        m_printerMACParam = m_printerMACParam.toUpperCase(Locale.US);

        if (!m_printerMACParam.matches("[0-9A-fa-f:]{17}")) {
            m_printerMACParam = formatBluetoothAddress(m_printerMACParam);
        }
        Bitmap anImage = getBitMap(bytesImage);

        DisplayPrintingStatusMessage("Processing image.." + " Height  " + anImage.getHeight() + " Width " + anImage.getWidth() + "  Count  " + anImage.getByteCount());
        startPrint(result, m_printerMACParam, context, anImage, feed);
    }


    public void DisplayPrintingStatusMessage(String MsgStr) {
        Log.d(TAG, MsgStr);
    }

    public String formatBluetoothAddress(String bluetoothAddress) {
        this.bluetoothAddress = bluetoothAddress;
        //Format MAC address string
        StringBuilder formattedBTAddress = new StringBuilder(bluetoothAddress);
        for (int bluetoothAddrPosition = 2; bluetoothAddrPosition <= formattedBTAddress.length() - 2; bluetoothAddrPosition += 3)
            formattedBTAddress.insert(bluetoothAddrPosition, ":");
        return formattedBTAddress.toString();
    }

    public void ShowMessageBox(final String message, final String title) {
        Log.d(TAG, title);
        Log.d(TAG, message);
    }

    public void startPrint(Result result, String macAddress, Context context, Bitmap anImage, int feed) {
        Bitmap bitmapPrint =  Utility.Tobitmap(anImage, PRINT_THREE_INCH, Utility.getHeight(PRINT_THREE_INCH, anImage.getWidth(), anImage.getHeight()));
        try {
            Print.LanguageEncode ="iso8859-1";
            DisplayPrintingStatusMessage("m_printerMAC " + macAddress);
           
            //Open bluetooth socket
            // if (!Print.IsOpened()) {
            //     final boolean isConnected = Print.PortOpen(context, "Bluetooth," + macAddress) == 0;
            //     DisplayPrintingStatusMessage("Establishing connection.." + isConnected);
            //     if (!isConnected) {
            //         throw new Exception("Printer not connected");
            //     }
            // }
            final boolean isConnected = Print.PortOpen(context, "Bluetooth," + macAddress) == 0;
            DisplayPrintingStatusMessage("Establishing connection.." + isConnected);
            if (!isConnected) {
                throw new Exception("Printer not connected");
            }
                
            // ≠-1: sending (to printer) success
            // -1: sending (to printer) failure
            //Sends data to printer
            DisplayPrintingStatusMessage("Sending data to printer..");
            int printed = Print.PrintBitmap(bitmapPrint, 1, 1);
            if (printed != -1) {
                Print.PrintAndLineFeed();
                Print.PrintAndLineFeed();
                Print.PrintAndLineFeed();
                DisplayPrintingStatusMessage("Print success. " + printed);
                Map<String, Object> map = MapUtil.createMap(true, "Success");
                result.success(JsonUtil.toJson(map));
            } else {
                Map<String, Object> map = MapUtil.createMap(false, "Failed to print, check your printer and retry again");
                result.error("", "", JsonUtil.toJson(map));
            }
            // if (Print.IsOpened()) {
            //     Print.PortClose();

            // }
        } catch (Exception e) {
            try {
                // if (Print.IsOpened()) {
                //     Print.PortClose();
                // }
            } catch (Exception c) {
                DisplayPrintingStatusMessage(c.getMessage() + "Application Error");
            }
            e.printStackTrace();
            DisplayPrintingStatusMessage("Error: " + e.getMessage());
            DisplayPrintingStatusMessage(e.getMessage() + "Application Error");
            Map<String, Object> map = MapUtil.createMap(false, e.toString());
            DisplayPrintingStatusMessage("Error: " + map);
            result.error("", "", JsonUtil.toJson(map));
        }
    }

    public Bitmap getBitMap(byte[] bytesImage) {
        return BitmapFactory.decodeByteArray(bytesImage, 0, bytesImage.length);
    }
}
