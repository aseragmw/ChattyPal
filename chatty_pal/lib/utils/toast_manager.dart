import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastManager {
  static FToast fToast = FToast();

  static void show(BuildContext context, String message, Color color) {
    fToast.init(context);
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12.0,
            ),
            Text(message),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
