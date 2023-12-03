import 'package:flutter/material.dart';
import 'package:sentinex/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  const ResponsiveLayout({super.key, required this.webScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= webSize) {
          return webScreenLayout;
        }
        //mobile screen
        return webScreenLayout;
      },
    );
  }
}
