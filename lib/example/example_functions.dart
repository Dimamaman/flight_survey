import 'package:flutter/material.dart';

/// Context KERAK EMAS — oddiy hisob-kitob, parametrlar bilan ishlaydi.
/// Testda to'g'ridan-to'g'ri chaqirish mumkin.
int addNumbers(int a, int b) {
  return a + b;
}

/// Context KERAK EMAS — email tekshiruv (pure function).
bool isValidEmail(String email) {
  if (email.isEmpty) return false;
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

/// Context KERAK — Flutter widget daraxtidan ma'lumot oladi
/// (masalan, theme, MediaQuery). Testda MaterialApp ichida
/// widget pump qilib, context olish kerak.
Brightness getThemeBrightness(BuildContext context) {
  return Theme.of(context).brightness;
}
