import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

/// UI constants for Zainpay
///
/// This file contains color definitions, text styles, and utility functions
/// for consistent UI presentation across the application

// Color constants
const String blackColor = "#0C0C0C";
const String dividerGreyColor = "#E6E6E6";
const String pendingColor = "#F7CE4D";
const String pendingDeliveryColor = "#5B5B5B";
const String failedColor = "#EB8481";
const String greenColor = "#02B133";
const String redColor = "#FC5D53";
const String darkRed = "#FC5D53";
const String textGreyColor = "#807F86";
const String paymentIconBlueBackgroundColor = "#E0EDFF";
const String paymentBlueBackgroundColor = "#006AFB";
const String textEmailColor = "#808080";
const String paymentCancelButtonColor = "#EAEEF3";
const String paymentTextColor = "#55586F";
const String whiteColor = "#FFFFFF";

// Formatters
var formatter = NumberFormat('#,###,###');
const paymentFontFamily = 'Airbnb Cereal App';

// Text styles
TextStyle blackTextStyle = TextStyle(
    fontFamily: paymentFontFamily,
    color: hexToColor(blackColor),
    fontWeight: FontWeight.w600,
    fontSize: 18);

/// Converts a hex color string to a Color object
///
/// @param code The hex color code (e.g., "#FFFFFF")
/// @return The Color object
Color hexToColor(String code) {
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
/// @param message The message to display
/// @param error Whether the notification is for an error
void showNotification({required String message, required bool error}) {
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
/// @param message The message to display
void showToast({required String message}) {
  showSimpleNotification(
      Container(
        margin: const EdgeInsets.only(bottom: 40, left: 120, right: 120),
        height: 40,
        width: 30,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: hexToColor(paymentIconBlueBackgroundColor),
            borderRadius: BorderRadius.circular(36)),
        child: Center(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: blackTextStyle.copyWith(
                color: hexToColor(paymentBlueBackgroundColor),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      background: Colors.transparent,
      elevation: 0,
      position: NotificationPosition.bottom);
}

/// Formats a number as currency
///
/// @param amount The amount to format
/// @return The formatted amount string
String formatCurrency(dynamic amount) {
  if (amount == null) return "₦0.00";

  try {
    final double parsedAmount = double.parse(amount.toString());
    return "₦${formatter.format(parsedAmount)}";
  } catch (e) {
    return "₦0.00";
  }
}
