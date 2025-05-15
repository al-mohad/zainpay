import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart' hide Toast;

/// Utility class for Zainpay UI components and helpers
class ZainpayViewUtils {
  // Prevent instantiation
  ZainpayViewUtils._();

  // Color constants
  static const String blackColor = "#0C0C0C";
  static const String dividerGreyColor = "#E6E6E6";
  static const String pendingColor = "#F7CE4D";
  static const String pendingDeliveryColor = "#5B5B5B";
  static const String failedColor = "#EB8481";
  static const String greenColor = "#02B133";
  static const String redColor = "#FC5D53";
  static const String darkRed = "#FC5D53";
  static const String textGreyColor = "#807F86";
  static const String paymentIconBlueBackgroundColor = "#E0EDFF";
  static const String paymentBlueBackgroundColor = "#006AFB";
  static const String textEmailColor = "#808080";
  static const String paymentCancelButtonColor = "#EAEEF3";
  static const String paymentTextColor = "#55586F";
  static const String whiteColor = "#FFFFFF";

  // Formatters
  static final formatter = NumberFormat('#,###,###');
  static const paymentFontFamily = 'Airbnb Cereal App';

  // Text styles
  static TextStyle get blackTextStyle => TextStyle(
      fontFamily: paymentFontFamily,
      color: hexToColor(blackColor),
      fontWeight: FontWeight.w600,
      fontSize: 18);

  /// Converts a hex color string to a Color object
  ///
  /// @param code The hex color code (e.g., "#FFFFFF")
  /// @return The Color object
  static Color hexToColor(String code) {
    if (code.startsWith('#')) {
      code = code.substring(1);
    }

    if (code.length == 6) {
      return Color(int.parse(code, radix: 16) + 0xFF000000);
    } else if (code.length == 8) {
      return Color(int.parse(code, radix: 16));
    }

    // Default fallback
    return Colors.black;
  }

  /// Shows a notification with a message
  ///
  /// @param context The BuildContext
  /// @param message The message to display
  /// @param error Whether the notification is for an error
  static void showNotification(BuildContext context,
      {required String message, required bool error}) {
    showSimpleNotification(
      Container(
        height: 50,
        width: 328,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: error ? hexToColor(redColor) : hexToColor(greenColor),
            borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          children: [
            error
                ? const Icon(FontAwesomeIcons.xmark,
                    size: 10, color: Colors.white)
                : const Icon(FontAwesomeIcons.checkDouble,
                    size: 10, color: Colors.white),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: blackTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
      background: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
    );
  }

  /// Shows a toast message
  ///
  /// @param context The BuildContext
  /// @param message The message to display
  static void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: hexToColor(blackColor),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Formats a number as currency
  ///
  /// @param amount The amount to format
  /// @return The formatted amount string
  static String formatCurrency(dynamic amount) {
    if (amount == null) return "₦0.00";

    try {
      final double parsedAmount = double.parse(amount.toString());
      return "₦${formatter.format(parsedAmount)}";
    } catch (e) {
      return "₦0.00";
    }
  }

  /// Shows a loading indicator
  ///
  /// @param context The BuildContext
  /// @param message Optional message to display
  static void showLoading(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      hexToColor(paymentBlueBackgroundColor),
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Hides the loading indicator
  ///
  /// @param context The BuildContext
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
