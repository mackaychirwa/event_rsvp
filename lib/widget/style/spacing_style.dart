import 'package:flutter/cupertino.dart';

import '../../constant/sizes.dart';


class CSpacingStyle{
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: CSizes.appBarHeight,
    left: CSizes.defaultSpace,
    right: CSizes.defaultSpace,
    bottom: CSizes.defaultSpace,
  );
}