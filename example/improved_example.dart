import 'package:flutter/material.dart';
import 'package:zainpay/utils/logger.dart';
import 'package:zainpay/utils/zainpay_view_utils.dart';
import 'package:zainpay/zainpay.dart';

/// An example app showcasing the Zainpay package
void main() {
  // Configure the logger
  ZainpayLogger().configure(showLogs: true, logLevel: 0);

  runApp(const ZainpayExampleApp());
}

/// The main app widget
class ZainpayExampleApp extends StatelessWidget {
  const ZainpayExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zainpay Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PaymentScreen(),
    );
  }
}

/// A screen that demonstrates payment functionality
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _amountController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zainpay Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Image.network(
                      'https://raw.githubusercontent.com/itcglobal/zainpay/main/zainpay.png',
                      height: 80,
                    ),
                  ),
                ),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),

                // Success message
                if (_successMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green.shade900),
                    ),
                  ),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Amount field
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (NGN)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                // Payment buttons
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _handleCardPayment,
                        icon: const Icon(Icons.credit_card),
                        label: const Text('Pay with Card'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      OutlinedButton.icon(
                        onPressed: _handleBankTransfer,
                        icon: const Icon(Icons.account_balance),
                        label: const Text('Pay with Bank Transfer'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles card payment
  Future<void> _handleCardPayment() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Initialize Zainpay
      final zainpay = Zainpay(
        context: context,
        publicKey: 'YOUR_PUBLIC_KEY', // Replace with your actual public key
        isTest: true, // Set to false for production
      );

      // Generate a unique transaction reference
      final txnRef = 'TXN_${DateTime.now().millisecondsSinceEpoch}';

      // Initialize card payment
      final response = await zainpay.initializeCardPayment(
        amount: _amountController.text,
        txnRef: txnRef,
        mobileNumber: _phoneController.text,
        zainboxCode:
            'YOUR_ZAINBOX_CODE', // Replace with your actual Zainbox code
        email: _emailController.text,
        callbackUrl: 'https://example.com/callback',
      );

      if (response != null && response.status == "200 OK" && mounted) {
        setState(() {
          _successMessage = 'Payment initialized successfully!';
        });

        // Show success message
        ZainpayViewUtils.showToast(
          context,
          'Payment initialized successfully!',
        );
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize payment. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handles bank transfer
  Future<void> _handleBankTransfer() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Initialize Zainpay
      final zainpay = Zainpay(
        context: context,
        publicKey: 'YOUR_PUBLIC_KEY', // Replace with your actual public key
        isTest: true, // Set to false for production
      );

      // Create a virtual account for bank transfer
      // Note: This is a placeholder since the createVirtualAccount method signature has changed
      // You would need to adapt this to the actual method signature in your implementation
      final response = await zainpay.createZainbox(_nameController.text,
          "payment", "https://example.com/callback", _emailController.text);

      if (response != null && mounted) {
        setState(() {
          _successMessage =
              'Zainbox created successfully! Code: ${response.data?.codeName ?? "N/A"}';
        });

        // Show success message
        ZainpayViewUtils.showToast(
          context,
          'Zainbox created successfully!',
        );
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Failed to create Zainbox. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Validates the form
  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }
}
