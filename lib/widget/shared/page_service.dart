import 'package:flutter/material.dart';
import '../../../../constant/colors.dart';
import 'global_verables.dart';

class PageService {
  static BuildContext? homeContext;
  Size pageSize(BuildContext context) {
    var context = GlobalVariable.navState.currentContext;
    if (context != null) {
      var size = MediaQuery.of(context).size;
      return Size(size.width, size.height);
    }
    return const Size(0, 0);
  }

  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  void errorshowSnackBar(BuildContext context, String content, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  static double? headerFontSize = 17;
  static double? textFontSize = 15;
  static SizedBox textSpaceS = const SizedBox(
    height: 5,
    width: 5,
  );
  static SizedBox textSpace = const SizedBox(
    height: 10,
    width: 10,
  );
  static SizedBox textSpaceL = const SizedBox(height: 15, width: 15);
  static SizedBox textSpacexL = const SizedBox(
    height: 20,
    width: 20,
  );
  static SizedBox textSpacexxL = const SizedBox(
    height: 30,
    width: 30,
  );
  static TextStyle bigHeaderStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: CColors.primaryColor,
      fontFamily: 'SF Pro Display');
  static TextStyle extraBigHeaderStyle = const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w700,
      color: CColors.primaryColor,
      fontFamily: 'SF Pro Display');
  static TextStyle headerStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: CColors.primaryColor);

  static TextStyle labelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: CColors.black,
      fontFamily: 'SF Pro Display');
  static TextStyle introLabelStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: CColors.black,
      fontFamily: 'SF Pro Display');
  static TextStyle normalLabelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Inter',
      color: CColors.black);
  static TextStyle emailLabelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: CColors.black,
      fontFamily: 'SF Pro Display');
  static TextStyle whitelabelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: CColors.white,
      fontFamily: 'SF Pro Display');
  static TextStyle textEditStyle =
      const TextStyle(fontSize: 14, fontFamily: 'SF Pro Display');
}
