import 'package:flutter/material.dart';
import 'dart:convert';

class CustomToast {
  static void show(BuildContext context, String message) {
    late OverlayEntry overlayEntry;

    final utfMessage = utf8.decode(message.runes.toList());

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100.0,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    // Added Expanded to contain the text
                    child: Text(
                      utfMessage,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      overlayEntry.remove();
                    },
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry);
  }
}
