import 'package:flutter/material.dart';
import 'package:zainpay/models/request/initialize_card_payment_request.dart';
import 'package:zainpay/models/request/update_zainbox_request.dart';
import 'package:zainpay/models/response/initialize_card_payment_response.dart';
import 'package:zainpay/utils/logger.dart';
import 'package:zainpay/utils/secure_storage.dart';

import '/models/request/create_zainbox_request.dart';
import '/models/request/get_all_zainboxes_request.dart';
import '/models/response/get_all_zainbox_accounts_response.dart';
import '/models/response/get_all_zainboxes_response.dart';
import '../models/request/get_all_zainbox_va_request.dart';
import '../models/response/create_zainbox_response.dart';

/// Main class for interacting with the Zainpay API
class Zainpay {
  final BuildContext context;
  final String publicKey;
  final bool isTest;

  // Logger instance
  late final ZainpayLogger _logger;

  // Secure storage instance
  late final SecureStorage _secureStorage;

  /// Creates a new Zainpay instance
  ///
  /// @param context The BuildContext
  /// @param publicKey The public key for the Zainpay API
  /// @param isTest Whether to use the test environment
  Zainpay({
    required this.context,
    required this.publicKey,
    required this.isTest,
  }) {
    _logger = ZainpayLogger();
    _secureStorage = SecureStorage();
  }

  /// Creates a new Zainbox
  ///
  /// @param name The name of the Zainbox
  /// @param tags Tags for the Zainbox
  /// @param callbackUrl The callback URL for the Zainbox
  /// @param email The email for the Zainbox
  /// @return A future that completes with the response
  Future<CreateZainboxResponse?> createZainbox(
    String name,
    String tags,
    String callbackUrl,
    String email,
  ) async {
    try {
      _logger.info('Creating Zainbox: $name');

      final createZainboxRequest = CreateZainboxRequest(
        name: name,
        tags: tags,
        callbackUrl: callbackUrl,
        email: email,
        publicKey: publicKey,
        isTest: isTest,
      );

      final response = await createZainboxRequest.createZainbox();

      if (response != null) {
        _logger
            .info('Zainbox created successfully: ${response.data?.codeName}');
      } else {
        _logger.warning('Failed to create Zainbox');
      }

      return response;
    } catch (e, stackTrace) {
      _logger.error('Error creating Zainbox', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Updates an existing Zainbox
  ///
  /// @param zainboxCode The code of the Zainbox to update
  /// @param name The new name of the Zainbox
  /// @param tags The new tags for the Zainbox
  /// @param callbackUrl The new callback URL for the Zainbox
  /// @param email The new email for the Zainbox
  /// @return A future that completes with the response
  Future<CreateZainboxResponse?> updateZainbox(
    String zainboxCode,
    String? name,
    String? tags,
    String? callbackUrl,
    String? email,
  ) async {
    try {
      _logger.info('Updating Zainbox: $zainboxCode');

      // Convert null values to empty strings to satisfy the API requirements
      final updateZainboxRequest = UpdateZainboxRequest(
        zainboxCode: zainboxCode,
        name: name ?? "",
        tags: tags ?? "",
        callbackUrl: callbackUrl ?? "",
        email: email ?? "",
        publicKey: publicKey,
        isTest: isTest,
      );

      final response = await updateZainboxRequest.updateZainbox();

      if (response != null) {
        _logger
            .info('Zainbox updated successfully: ${response.data?.codeName}');
      } else {
        _logger.warning('Failed to update Zainbox');
      }

      return response;
    } catch (e, stackTrace) {
      _logger.error('Error updating Zainbox', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Initializes a card payment
  ///
  /// @param amount The amount to charge
  /// @param txnRef The transaction reference
  /// @param mobileNumber The mobile number of the customer
  /// @param zainboxCode The Zainbox code
  /// @param email The email of the customer
  /// @param callbackUrl The callback URL for the payment
  /// @return A future that completes with the response
  Future<CardPaymentResponse?> initializeCardPayment({
    required String amount,
    required String txnRef,
    required String mobileNumber,
    required String zainboxCode,
    required String email,
    required String callbackUrl,
  }) async {
    try {
      _logger.info('Initializing card payment: $txnRef');

      final cardPaymentRequest = CardPaymentRequest(
        txnRef: txnRef,
        amount: amount,
        mobileNumber: mobileNumber,
        zainboxCode: zainboxCode,
        emailAddress: email,
        callBackUrl: callbackUrl,
        publicKey: publicKey,
        isTest: isTest,
      );

      final response = await cardPaymentRequest.initializeCardPayment();

      if (response != null) {
        _logger.info('Card payment initialized successfully');
      } else {
        _logger.warning('Failed to initialize card payment');
      }

      return response;
    } catch (e, stackTrace) {
      _logger.error('Error initializing card payment',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Gets all Zainboxes
  ///
  /// @return A future that completes with the response
  Future<GetAllZainboxesResponse?> getAllZainboxes() async {
    try {
      _logger.info('Getting all Zainboxes');

      final getAllZainboxesRequest = GetAllZainboxesRequest(
        isTest: isTest,
        publicKey: publicKey,
      );

      final response = await getAllZainboxesRequest.getAllZainboxes();

      if (response != null) {
        _logger.info('Got all Zainboxes successfully');
      } else {
        _logger.warning('Failed to get all Zainboxes');
      }

      return response;
    } catch (e, stackTrace) {
      _logger.error('Error getting all Zainboxes',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Gets all accounts for a Zainbox
  ///
  /// @param zainboxCodeName The code or name of the Zainbox
  /// @return A future that completes with the response
  Future<ZainboxAccountResponse?> getAllZainboxAccounts({
    required String zainboxCodeName,
  }) async {
    try {
      _logger.info('Getting all accounts for Zainbox: $zainboxCodeName');

      final getAllZainboxAccountsRequest = GetAllZainboxAccountsRequest(
        zainboxCodeName: zainboxCodeName,
        publicKey: publicKey,
        isTest: isTest,
      );

      final response =
          await getAllZainboxAccountsRequest.getAllZainboxAccounts();

      if (response != null) {
        _logger.info('Got all Zainbox accounts successfully');
      } else {
        _logger.warning('Failed to get all Zainbox accounts');
      }

      return response;
    } catch (e, stackTrace) {
      _logger.error('Error getting all Zainbox accounts',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
