import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Config {
  static Color backgroundColor = const Color.fromRGBO(230, 235, 240, 1);
  static Color tilesColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color textcolor = const Color.fromRGBO(50, 50, 50, 1);
  static AlertStyle get alertConfig {
    return AlertStyle(
      backgroundColor: Config.tilesColor,
      alertAlignment: Alignment.center,
      animationType: AnimationType.shrink,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        color: Config.textcolor,
        fontWeight: FontWeight.normal,
        fontFamily: 'Montserrat',
        fontSize: 15,
      ),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'Montserrat',
        color: Config.textcolor,
      ),
      descTextAlign: TextAlign.left,
      animationDuration: const Duration(milliseconds: 100),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
    );
  }
/*   static changeColor(dtheme) {
    dtheme = !dtheme;
    if (dtheme) {
      backgroundColor = const Color.fromRGBO(0, 0, 0, 1);
      tilesColor = const Color.fromRGBO(40, 40, 40, 1);
      textcolor = const Color.fromRGBO(255, 255, 255, 1);
    } else {
      backgroundColor = const Color.fromRGBO(230, 235, 240, 1);
      tilesColor = const Color.fromRGBO(255, 255, 255, 1);
      textcolor = const Color.fromRGBO(50, 50, 50, 1);
    }
  } */
}
