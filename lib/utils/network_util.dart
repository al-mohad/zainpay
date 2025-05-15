import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zainpay/utils/logger.dart';

/// A utility class for making HTTP requests
class NetworkUtil {
  // Singleton instance
  static final NetworkUtil _instance = NetworkUtil._internal();

  // Factory constructor to return the singleton instance
  factory NetworkUtil() => _instance;

  // Private constructor
  NetworkUtil._internal();

  // Logger instance
  final _logger = ZainpayLogger();

  // Default timeout duration
  static const Duration _defaultTimeout = Duration(seconds: 30);

  // Default headers
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Make a GET request
  ///
  /// @param url The URL to make the request to
  /// @param headers Additional headers to include in the request
  /// @param timeout The timeout duration for the request
  /// @return A future that completes with the response
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      _logger.debug('Making GET request to $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {..._defaultHeaders, ...?headers},
      ).timeout(timeout);

      _logResponse(response);

      return response;
    } catch (e, stackTrace) {
      _logger.error('GET request to $url failed',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Make a POST request
  ///
  /// @param url The URL to make the request to
  /// @param body The body of the request
  /// @param headers Additional headers to include in the request
  /// @param timeout The timeout duration for the request
  /// @return A future that completes with the response
  Future<http.Response> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      final String bodyString = body is String ? body : jsonEncode(body);

      _logger.debug('Making POST request to $url');
      _logger.debug('Request body: $bodyString');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {..._defaultHeaders, ...?headers},
            body: bodyString,
          )
          .timeout(timeout);

      _logResponse(response);

      return response;
    } catch (e, stackTrace) {
      _logger.error('POST request to $url failed',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Make a PUT request
  ///
  /// @param url The URL to make the request to
  /// @param body The body of the request
  /// @param headers Additional headers to include in the request
  /// @param timeout The timeout duration for the request
  /// @return A future that completes with the response
  Future<http.Response> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      final String bodyString = body is String ? body : jsonEncode(body);

      _logger.debug('Making PUT request to $url');
      _logger.debug('Request body: $bodyString');

      final response = await http
          .put(
            Uri.parse(url),
            headers: {..._defaultHeaders, ...?headers},
            body: bodyString,
          )
          .timeout(timeout);

      _logResponse(response);

      return response;
    } catch (e, stackTrace) {
      _logger.error('PUT request to $url failed',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Make a DELETE request
  ///
  /// @param url The URL to make the request to
  /// @param headers Additional headers to include in the request
  /// @param timeout The timeout duration for the request
  /// @return A future that completes with the response
  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      _logger.debug('Making DELETE request to $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {..._defaultHeaders, ...?headers},
      ).timeout(timeout);

      _logResponse(response);

      return response;
    } catch (e, stackTrace) {
      _logger.error('DELETE request to $url failed',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Parse a response as JSON
  ///
  /// @param response The response to parse
  /// @return The parsed JSON
  dynamic parseResponse(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e, stackTrace) {
      _logger.error('Failed to parse response',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Check if a response is successful
  ///
  /// @param response The response to check
  /// @return True if the response is successful, false otherwise
  bool isSuccessful(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Log a response
  ///
  /// @param response The response to log
  void _logResponse(http.Response response) {
    _logger.debug('Response status code: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      _logger.debug('Response body: ${response.body}');
    } else {
      _logger
          .warning('Request failed with status code: ${response.statusCode}');
      _logger.warning('Response body: ${response.body}');
    }
  }
}
