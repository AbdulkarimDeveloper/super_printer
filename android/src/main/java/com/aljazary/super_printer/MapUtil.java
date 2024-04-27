package com.aljazary.super_printer;
import java.util.Map;
import java.util.HashMap;
public class MapUtil {
    public static Map<String, Object> createMap(boolean status, String message) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("status", status);
        map.put("message", message);
        return map;
    }
}
