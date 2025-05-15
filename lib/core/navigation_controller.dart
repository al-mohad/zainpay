import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zainpay/core/transaction_callback.dart';
import 'package:zainpay/models/response/init_payment_response.dart';
import 'package:zainpay/view/inapp_browser.dart';

import '../models/request/standard_request.dart';

class NavigationController {
  final TransactionCallBack _callBack;

  NavigationController(this._callBack);

  /// Initiates initial transaction to get web url
  startTransaction(final StandardRequest request) async {
    try {
      final InitPaymentResponse? initPaymentResponse =
          await request.initializePayment(request.publicKey);
      if (initPaymentResponse?.status == "200 OK") {
        openBrowser(initPaymentResponse?.data ?? "", request.callBackUrl);
      }
    } catch (error) {
      rethrow;
    }
  }

  /// Opens browser with URL returned from startTransaction()
  openBrowser(final String url, final String redirectUrl,
      [final bool isTestMode = false]) async {
    final ZainpayInAppBrowser browser =
        ZainpayInAppBrowser(callBack: _callBack);

    // Use a simplified approach that works with both v5.x and v6.x
    // This avoids using deprecated APIs directly
    try {
      // Create a WebUri from the URL string (compatible with flutter_inappwebview 6.x)
      final webUri = WebUri(url);

      // Create a URLRequest with the WebUri
      final urlRequest = URLRequest(url: webUri);

      // Open the URL request without specific options
      // This approach works with both v5.x and v6.x
      await browser.openUrlRequest(urlRequest: urlRequest);
    } catch (e) {
      // If there's an error, log it silently and rethrow
      rethrow;
    }
  }
}
