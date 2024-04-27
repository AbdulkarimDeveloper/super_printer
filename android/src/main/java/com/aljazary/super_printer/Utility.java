package com.aljazary.super_printer;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.os.Build;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Utility {
    public static void checkBlueboothPermission(Activity context, String permission, String[] requestPermissions, Callback callback) {
        if (Build.VERSION.SDK_INT >= 23) {
            if (ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(context, requestPermissions, 100);
            } else {
                callback.permit();
                return;
            }
        } else {
            callback.pass();
        }
    }

    public interface Callback {
        /**
         * API>=23
         */
        void permit();


        /**
         * API<23
         */
        void pass();
    }

    public static void writeBytesToFile(InputStream is, File file) throws IOException {
        FileOutputStream fos = null;
        try {
            byte[] data = new byte[2048];
            int nbread = 0;
            fos = new FileOutputStream(file);
            while ((nbread = is.read(data)) > -1) {
                fos.write(data, 0, nbread);
            }
        } catch (Exception ex) {
        } finally {
            if (fos != null) {
                fos.close();
            }
        }
    }

    public static Bitmap Tobitmap(Bitmap bitmap, int width, int height) {

        Bitmap target = Bitmap.createBitmap(width, height, bitmap.getConfig());
        Canvas canvas = new Canvas(target);
        canvas.drawBitmap(bitmap, null, new Rect(0, 0, target.getWidth(), target.getHeight()), null);
        return target;
    }

    public static int getHeight(int width, int pageWidthPoint, int pageHeightPoint) {
        double bili = width / (double) pageWidthPoint;
        return (int) (pageHeightPoint * bili);
    }

    public static Bitmap Tobitmap90(Bitmap bitmap) {
        Matrix matrix = new Matrix();
        matrix.setRotate(90);
        bitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        return bitmap;
    }

    public static boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
        return pattern.matcher(str).matches();
    }

    public static void show(final Context context, final String message) {
        ((Activity) context).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
            }
        });

    }

    public static byte[] InputStreamToByte(InputStream is) throws IOException {
        ByteArrayOutputStream bytestream = new ByteArrayOutputStream();
        int ch;
        while ((ch = is.read()) != -1) {
            bytestream.write(ch);
        }
        byte imgdata[] = bytestream.toByteArray();
        bytestream.close();
        return imgdata;
    }

    public static byte[] hexToByte(String path) {
        Pattern p = Pattern.compile("\\s*|\t|\r|\n");
        Matcher ma = p.matcher(path);
        path = ma.replaceAll("");
        int m = path.length() / 2;
        if (m * 2 < path.length()) {
            m++;
        }
        String[] strs = new String[m];
        int j = 0;
        for (int i = 0; i < path.length(); i++) {
            if (i % 2 == 0) {
                strs[j] = "" + path.charAt(i);
            } else {
                strs[j] = strs[j] + path.charAt(i);
                j++;
            }
        }
        byte[] by = new byte[strs.length];
        for (int i = 0; i < strs.length; i++) {
            if (strs[i].length() == 2) {
                by[i] = Integer.valueOf(strs[i], 16).byteValue();
            }
        }
        return by;
    }
}