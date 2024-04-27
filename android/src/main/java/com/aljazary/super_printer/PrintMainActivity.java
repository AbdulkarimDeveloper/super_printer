package com.aljazary.super_printer;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.util.Log;

import java.util.Locale;
import java.util.Map;

import honeywell.connection.ConnectionBase;
import honeywell.connection.Connection_Bluetooth;
import honeywell.printer.DocumentExPCL_LP;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

import android.widget.Toast;
import android.content.Context;

public class PrintMainActivity {
    //    <string-array name="printHeadWidth_array">
//         <item >384 (2 in.)</item>
//         <item >576 (3 in.)</item>
//         <item >832 (4 in.)</item>
//     </string-array>
    //Keys to pass data to Connection Activity
    private String TAG = "PRINTTAG";
    Context context;

    ConnectionBase conn = null;
    private int m_printHeadWidth = 576;
    static final int CONFIG_CONNECTION_REQUEST = 0; // for Connection Settings
    //Document and Parameter Objects
    private DocumentExPCL_LP docExPCL_LP;

    // use to update the UI information.
    private final Handler m_handler = new Handler(); // Main thread

    byte[] printData = {0};

    // Configuration files to load
    public void onPrint(byte[] bytesImage, String m_printerMACParam, int width, Result result, int feed, Context context) {
        this.context = context;
        this.m_printHeadWidth = width;
        m_printerMACParam = m_printerMACParam.toUpperCase(Locale.US);

        if (!m_printerMACParam.matches("[0-9A-fa-f:]{17}")) {
            m_printerMACParam = formatBluetoothAddress(m_printerMACParam);
        }
        printData = new byte[]{0};
        docExPCL_LP = new DocumentExPCL_LP(3);
        Bitmap anImage = getBitMap(bytesImage);
        DisplayPrintingStatusMessage("Processing image.." + " " + this.m_printHeadWidth);
        docExPCL_LP.writeImage(anImage, m_printHeadWidth);

        for (int i = 0; i < feed; i++) {
            docExPCL_LP.writeText("\n\n\n\n");
        }
        printData = docExPCL_LP.getDocumentData();
        // }
        startPrint(result, m_printerMACParam);

    }


    // public void DisplayPrintingStatusMessage(String MsgStr) {
    //     Log.d(TAG , MsgStr);
    // }

    public void DisplayPrintingStatusMessage(String MsgStr) {
        Log.d(TAG, MsgStr);
        // Toast.makeText(context,MsgStr, Toast.LENGTH_LONG).show();
    }

    public String formatBluetoothAddress(String bluetoothAddr) {
        //Format MAC address string
        StringBuilder formattedBTAddress = new StringBuilder(bluetoothAddr);
        for (int bluetoothAddrPosition = 2; bluetoothAddrPosition <= formattedBTAddress.length() - 2; bluetoothAddrPosition += 3)
            formattedBTAddress.insert(bluetoothAddrPosition, ":");
        return formattedBTAddress.toString();
    }


    // call this function to  start print
    ////////////////// print start here

    public void startPrint(Result result, String macAddress) {
        //Connection
        try {
            //Reset connection object

            //====FOR BLUETOOTH CONNECTIONS========//
            DisplayPrintingStatusMessage("m_printerMAC " + macAddress);

            //  if(conn==null) {  
            conn = Connection_Bluetooth.createClient(macAddress, true);

            DisplayPrintingStatusMessage("Establishing connection 1.." + conn.getIsOpen());

            //Open bluetooth socket
            if (conn.getIsOpen() == false) {
                final boolean isConnected = conn.open();
                DisplayPrintingStatusMessage("Establishing connection 2.." + isConnected);
                if (isConnected == false) {
                    throw new Exception("Printer not connected");
                }
            }

            //Sends data to printer
            DisplayPrintingStatusMessage("Sending data to printer..");
            int bytesWritten = 0;
            int bytesToWrite = 1024;
            int totalBytes = printData.length;
            int remainingBytes = totalBytes;
            while (bytesWritten < totalBytes) {
                if (remainingBytes < bytesToWrite)
                    bytesToWrite = remainingBytes;

                //Send data, 1024 bytes at a time until all data sent
                conn.write(printData, bytesWritten, bytesToWrite);
                bytesWritten += bytesToWrite;
                remainingBytes = remainingBytes - bytesToWrite;
                Thread.sleep(100);
            }

            DisplayPrintingStatusMessage("Print success.");


            Map<String, Object> map = MapUtil.createMap(true, "Success");
            result.success(JsonUtil.toJson(map));
            if (conn.getIsOpen()) {
                conn.close();

            }
        } catch (Exception e) {
            e.printStackTrace();
            DisplayPrintingStatusMessage("Error: " + e.getMessage());
            Map<String, Object> map = MapUtil.createMap(false, e.toString());
            DisplayPrintingStatusMessage("Error: " + map);
            result.error("", "", JsonUtil.toJson(map));
        }
    }

    public Bitmap getBitMap(byte[] bytesImage) {
        Log.d(TAG, "Bitmap length before: " + bytesImage.length);
        return BitmapFactory.decodeByteArray(bytesImage, 0, bytesImage.length);

    }

}

