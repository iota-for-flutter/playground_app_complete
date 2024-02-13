import 'package:flutter/material.dart';

import './data/constants.dart';
import './data/example_provider.dart';

extension BuildContextExt on BuildContext {
  bool get isLargeScreen {
    Size size = MediaQuery.of(this).size;
    //double width = size.width > size.height ? size.width : size.height;

    return size.width > mobileWidth;
  }

  // Accounts for extremely large screens
  // Kai: I renamed the original "isExtended" to "isVeryLargeScreen"
  // to avoid confusion because "Extended" is a class in Flutter
  bool get isVeryLargeScreen {
    Size size = MediaQuery.of(this).size;
    //double width = size.width > size.height ? size.width : size.height;

    return size.width > tabletWidth;
  }

  ExampleProvider get provider => ExampleProvider.of(this);
}
