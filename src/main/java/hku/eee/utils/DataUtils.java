package hku.eee.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DataUtils {

    public static String dateToString(Date date, String pattern) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        String res = dateFormat.format(date);
        return res;
    }

    public static Date stringToDate(String date, String pattern) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        Date res = dateFormat.parse(date);
        return res;
    }
}
