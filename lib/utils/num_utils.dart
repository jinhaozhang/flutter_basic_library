import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';


/// Num Util.
class NumUtil {
  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueStr(String valueStr, {int? fractionDigits}) {
    double? value = double.tryParse(valueStr);
    return fractionDigits == null
        ? value
        : getNumByValueDouble(value, fractionDigits);
  }

  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueDouble(double? value, int fractionDigits) {
    if (value == null) return null;
    String valueStr = value.toStringAsFixed(fractionDigits);
    return fractionDigits == 0
        ? int.tryParse(valueStr)
        : double.tryParse(valueStr);
  }

  /// get int by value str.
  static int? getIntByValueStr(String valueStr, {int? defValue = 0}) {
    return int.tryParse(valueStr) ?? defValue;
  }

  /// get double by value str.
  static double? getDoubleByValueStr(String valueStr, {double? defValue = 0}) {
    return double.tryParse(valueStr) ?? defValue;
  }

  ///isZero
  static bool isZero(num? value) {
    return value == null || value == 0;
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static double add(num a, num b) {
    return addDec(a, b).toDouble();
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static double subtract(num a, num b) {
    return subtractDec(a, b).toDouble();
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static double multiply(num a, num b) {
    return multiplyDec(a, b).toDouble();
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static double divide(num a, num b) {
    return divideDec(a, b).toDouble();
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static Decimal addDec(num a, num b) {
    return addDecStr(a.toString(), b.toString());
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static Decimal subtractDec(num a, num b) {
    return subtractDecStr(a.toString(), b.toString());
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static Decimal multiplyDec(num a, num b) {
    return multiplyDecStr(a.toString(), b.toString());
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static Decimal divideDec(num a, num b) {
    return divideDecStr(a.toString(), b.toString());
  }

  /// 余数
  static Decimal remainder(num a, num b) {
    return remainderDecStr(a.toString(), b.toString());
  }

  /// Relational less than operator.
  static bool lessThan(num a, num b) {
    return lessThanDecStr(a.toString(), b.toString());
  }

  /// Relational less than or equal operator.
  static bool thanOrEqual(num a, num b) {
    return thanOrEqualDecStr(a.toString(), b.toString());
  }

  /// Relational greater than operator.
  static bool greaterThan(num a, num b) {
    return greaterThanDecStr(a.toString(), b.toString());
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqual(num a, num b) {
    return greaterOrEqualDecStr(a.toString(), b.toString());
  }

  /// 加
  static Decimal addDecStr(String a, String b) {
    return Decimal.parse(a) + Decimal.parse(b);
  }

  /// 减
  static Decimal subtractDecStr(String a, String b) {
    return Decimal.parse(a) - Decimal.parse(b);
  }

  /// 乘
  static Decimal multiplyDecStr(String a, String b) {
    return Decimal.parse(a) * Decimal.parse(b);
  }

  /// 除
  static Decimal divideDecStr(String a, String b) {
    Rational value = Decimal.parse(a) / Decimal.parse(b);
    return value.toDecimal();
  }

  /// 余数
  static Decimal remainderDecStr(String a, String b) {
    return Decimal.parse(a) % Decimal.parse(b);
  }

  /// Relational less than operator.
  static bool lessThanDecStr(String a, String b) {
    return Decimal.parse(a) < Decimal.parse(b);
  }

  /// Relational less than or equal operator.
  static bool thanOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) <= Decimal.parse(b);
  }

  /// Relational greater than operator.
  static bool greaterThanDecStr(String a, String b) {
    return Decimal.parse(a) > Decimal.parse(b);
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) >= Decimal.parse(b);
  }

  ///取小数点后几位
  ///num 数据
  ///location 几位
  String formatNum(double num, int location) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        location) {
      //小数点后有几位小数
      return num.toStringAsFixed(location)
          .substring(0, num.toString().lastIndexOf(".") + location + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + location + 1)
          .toString();
    }
  }

  static bool isNumeric(String str) {
    try{
      var value = num.parse(str);
      return true;
    } on FormatException {
      return false;
    }
  }

}

class ConvertNumberToChineseMoneyWords{
  // 大写数字
  static List<String> NUMBERS = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十",""];

  static String toChinese(int index) {
    if(index > 100){
      return index.toString();
    }
    StringBuffer stringBuffer = StringBuffer();
    if(index / 10 < 1){
      return NUMBERS[index];
    }
    int tenUnit = (index / 10).toInt();
    int remainder = index % 10;
    if(remainder == 9){
      tenUnit++;
      remainder = 10;
    }
    if(tenUnit == 1){
      stringBuffer..write("十")..write(NUMBERS[remainder]);
      return stringBuffer.toString();
    }
    stringBuffer..write(NUMBERS[tenUnit - 1])..write("十")..write(NUMBERS[remainder]);
    return stringBuffer.toString();
  }
}