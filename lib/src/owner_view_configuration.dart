import 'package:flutter/material.dart';

class OwnerViewConfiguration {
  final double height;
  final double? widthPerOwner;
  final Color backgroundColor;
  final Widget? divider;

  const OwnerViewConfiguration({
    this.height = 50,
    this.widthPerOwner,
    this.backgroundColor = Colors.transparent,
    this.divider,
  });
}
