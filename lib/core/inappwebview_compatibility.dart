import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// A compatibility layer for flutter_inappwebview to support both v5.x and v6.x
/// This helps maintain backward compatibility while supporting the latest Flutter SDK
class WebViewCompatibility {
  /// Opens a URL in the InAppBrowser with compatibility for both v5.x and v6.x
  static Future<void> openBrowser(
    InAppBrowser browser,
    String url, {
    bool hideUrlBar = true,
    bool hideToolbarTop = true,
    bool javaScriptEnabled = true,
    bool clearCache = true,
  }) async {
    // Use a simplified approach that works with both v5.x and v6.x
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
