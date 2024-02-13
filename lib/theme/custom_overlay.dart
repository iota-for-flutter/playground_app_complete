import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'custom_colors.dart';

class CustomOverlay {
  CustomOverlay();

  show(BuildContext context) {
    return Loader.show(
      context,
      isSafeAreaOverlay: false,
      isBottomBarOverlay: true,
      overlayColor: Colors.black45,
      progressIndicator: const CircularProgressIndicator(
          backgroundColor: CustomColors.iotaGreen),
      themeData: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white,
        ),
      ),
    );
  }

  hide() {
    return Loader.hide();
  }
}
