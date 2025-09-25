import 'dart:math';

/// Gets the current date time UTC string in ISO 8601. This is used as a base
/// for generating the hash codes
String dateTimeNowStr() => DateTime.now().toUtc().toIso8601String();

/// Generates a hash code from a given string [str] that is [len] characters
/// long. If needed, [off] will be used to slightly modify the string to get a
/// different hash.
String generateHashCode(String str, int len, [int off = 0]) {
  int hash = 0;
  // For every character in the string, hash it.
  for (int i = 0; i < str.length; i++) {
    hash += pow((str.codeUnitAt(i) + off), i) as int;
  }

  // Make sure the string is not longer then length
  hash %= 1 << (len * 4);

  // Hexify it and pad if needed, then return
  return hash.toRadixString(16).padLeft(len, '0').toUpperCase();
}
