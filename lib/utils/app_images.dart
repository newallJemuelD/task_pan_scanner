import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImages {
  static Widget getSVGImage(
    String url,
    BuildContext context, {
    Color? color,
    dynamic width,
    dynamic height,
  }) {
    return SvgPicture.asset(
      url,
      color: color,
      height: height,
      width: width,
    );
  }

  static Widget panCardImage(
    BuildContext context, {
    bool? isColor,
    double? width,
    double? height,
  }) {
    return getSVGImage(
      'lib/assets/images/pan_card.svg',
      context,
      width: width,
      height: height,
    );
  }
}
