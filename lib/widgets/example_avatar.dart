import 'package:flutter/material.dart';

import '../models/example_model.dart';

class ExampleAvatar extends StatelessWidget {
  const ExampleAvatar({Key? key, required this.category, this.radius = 25})
      : super(key: key);

  final double radius;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: category.backgroundColor ?? Colors.grey[200]!,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(category.iconPath),
      ),
    );
  }
}
