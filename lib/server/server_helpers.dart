import 'dart:math';

String dateTimeNowStr() => DateTime.now().toUtc().toIso8601String();

String generateHashCode(String str, int len, [int off = 0]) {
  int hash = 0;
  for (int i = 0; i < str.length; i++) {
    hash += pow((str.codeUnitAt(i) + off), i) as int;
  }

  hash %= 1 << (len * 4);

  return hash.toRadixString(16).padLeft(len, '0').toUpperCase();
}
