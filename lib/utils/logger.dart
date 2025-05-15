import 'package:flutter/foundation.dart';

/// A simple logging utility for Zainpay
/// 
/// This class provides methods for logging messages at different levels
/// and can be configured to show or hide logs based on the environment.
class ZainpayLogger {
  // Singleton instance
  static final ZainpayLogger _instance = ZainpayLogger._internal();
  
  // Factory constructor to return the singleton instance
  factory ZainpayLogger() => _instance;
  
  // Private constructor
  ZainpayLogger._internal();
  
  // Whether to show logs
  bool _showLogs = true;
  
  // Log levels
  static const int _kDebug = 0;
  static const int _kInfo = 1;
  static const int _kWarning = 2;
  static const int _kError = 3;
  
  // Current log level
  int _logLevel = _kDebug;
  
  /// Configure the logger
  /// 
  /// @param showLogs Whether to show logs
  /// @param logLevel The minimum log level to show (0=debug, 1=info, 2=warning, 3=error)
  void configure({bool? showLogs, int? logLevel}) {
    if (showLogs != null) {
      _showLogs = showLogs;
    }
    
    if (logLevel != null) {
      _logLevel = logLevel;
    }
  }
  
  /// Log a debug message
  /// 
  /// @param message The message to log
  /// @param tag An optional tag to identify the source of the log
  void debug(String message, {String tag = 'Zainpay'}) {
    _log(_kDebug, message, tag: tag);
  }
  
  /// Log an info message
  /// 
  /// @param message The message to log
  /// @param tag An optional tag to identify the source of the log
  void info(String message, {String tag = 'Zainpay'}) {
    _log(_kInfo, message, tag: tag);
  }
  
  /// Log a warning message
  /// 
  /// @param message The message to log
  /// @param tag An optional tag to identify the source of the log
  void warning(String message, {String tag = 'Zainpay'}) {
    _log(_kWarning, message, tag: tag);
  }
  
  /// Log an error message
  /// 
  /// @param message The message to log
  /// @param error The error object
  /// @param stackTrace The stack trace
  /// @param tag An optional tag to identify the source of the log
  void error(String message, {Object? error, StackTrace? stackTrace, String tag = 'Zainpay'}) {
    _log(_kError, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Internal method to log a message
  /// 
  /// @param level The log level
  /// @param message The message to log
  /// @param tag The tag to identify the source of the log
  /// @param error The error object
  /// @param stackTrace The stack trace
  void _log(int level, String message, {required String tag, Object? error, StackTrace? stackTrace}) {
    if (!_showLogs || level < _logLevel) {
      return;
    }
    
    String levelString;
    switch (level) {
      case _kDebug:
        levelString = 'DEBUG';
        break;
      case _kInfo:
        levelString = 'INFO';
        break;
      case _kWarning:
        levelString = 'WARNING';
        break;
      case _kError:
        levelString = 'ERROR';
        break;
      default:
        levelString = 'UNKNOWN';
    }
    
    final logMessage = '[$tag] $levelString: $message';
    
    if (kDebugMode) {
      if (error != null) {
        print('$logMessage\nError: $error');
        if (stackTrace != null) {
          print('StackTrace: $stackTrace');
        }
      } else {
        print(logMessage);
      }
    }
  }
}
