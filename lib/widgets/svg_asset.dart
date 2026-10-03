import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAsset extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const SvgAsset({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    String fullPath = assetName;
    if (!fullPath.startsWith('assets/')) {
      fullPath = 'assets/images/$assetName';
    }
    if (!fullPath.endsWith('.svg')) {
      fullPath = '$fullPath.svg';
    }

    return SvgPicture.asset(
      fullPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (BuildContext context) => SizedBox(
        width: width ?? 24,
        height: height ?? 24,
      ),
    );
  }
}
