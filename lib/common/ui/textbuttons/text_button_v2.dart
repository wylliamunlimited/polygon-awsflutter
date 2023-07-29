import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TextButtonV2 extends HookConsumerWidget {
  TextButtonV2({
    super.key,
    required this.onTap,
    required this.componentOpacity,
    required this.text,
    this.width = 230,
    this.height = 75,
  });

  final void Function()? onTap;
  final double componentOpacity;
  final String text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 1, end: componentOpacity),
      builder: (context, value, child) => GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: value,
          child: InkWell(
            child: Container(
              height: height,
              width: width,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontSize: min<double>(height, width) / 4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
