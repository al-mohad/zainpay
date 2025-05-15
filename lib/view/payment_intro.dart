import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zainpay/models/request/create_va_request.dart';
import 'package:zainpay/models/request/standard_request.dart';
import 'package:zainpay/models/response/init_payment_response.dart';
import 'package:zainpay/utils/zainpay_view_utils.dart';

import 'bank_transfer_payment.dart';
import 'card_payment.dart';

/// A widget that displays payment options to the user
class PaymentIntro extends StatefulWidget {
  final StandardRequest standardRequest;
  final BuildContext context;

  const PaymentIntro({
    super.key,
    required this.standardRequest,
    required this.context,
  });

  @override
  PaymentIntroState createState() => PaymentIntroState();
}

class PaymentIntroState extends State<PaymentIntro> {
  String? sessionId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    try {
      final response = await startTransaction(widget.standardRequest);
      if (mounted) {
        setState(() {
          sessionId = response?.sessionId;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ZainpayViewUtils.showToast(context, "Failed to initialize payment: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _isLoading 
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: ZainpayViewUtils.hexToColor(ZainpayViewUtils.paymentBlueBackgroundColor),
                  ),
                ),
              ) 
            : _buildPaymentOptions(),
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    final formatter = ZainpayViewUtils.formatter;
    final blackTextStyle = ZainpayViewUtils.blackTextStyle;
    final hexToColor = ZainpayViewUtils.hexToColor;
    
    return Column(
      children: [
        // Header with amount and cancel button
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20, right: 16, left: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.standardRequest.email,
                    style: blackTextStyle.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NGN ${formatter.format(double.parse(widget.standardRequest.amount))}',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: hexToColor(ZainpayViewUtils.paymentCancelButtonColor),
                ),
                width: 75,
                height: 32,
                child: MaterialButton(
                  onPressed: () => Navigator.pop(widget.context),
                  child: Text(
                    'Cancel',
                    style: blackTextStyle.copyWith(
                      color: hexToColor(ZainpayViewUtils.paymentTextColor),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Divider
        SizedBox(
          height: 18,
          child: Divider(
            height: 1,
            thickness: 1,
            color: hexToColor(ZainpayViewUtils.dividerGreyColor),
          ),
        ),
        
        // Card payment option
        _buildPaymentOption(
          icon: FontAwesomeIcons.ccVisa,
          title: 'Pay with Card',
          onTap: _handleCardPayment,
        ),
        
        // Divider
        SizedBox(
          height: 18,
          child: Divider(
            height: 1,
            thickness: 1,
            color: hexToColor(ZainpayViewUtils.dividerGreyColor),
          ),
        ),
        
        // Bank transfer option
        _buildPaymentOption(
          icon: FontAwesomeIcons.buildingColumns,
          title: 'Pay with Bank Transfer',
          onTap: _handleBankTransfer,
        ),
        
        // Divider
        SizedBox(
          height: 18,
          child: Divider(
            height: 1,
            thickness: 1,
            color: hexToColor(ZainpayViewUtils.dividerGreyColor),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final blackTextStyle = ZainpayViewUtils.blackTextStyle;
    final hexToColor = ZainpayViewUtils.hexToColor;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: hexToColor(ZainpayViewUtils.paymentIconBlueBackgroundColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                size: 12,
                color: hexToColor(ZainpayViewUtils.blackColor),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: blackTextStyle.copyWith(
                color: hexToColor(ZainpayViewUtils.blackColor),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: hexToColor(ZainpayViewUtils.paymentCancelButtonColor),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                FontAwesomeIcons.chevronRight,
                size: 12,
                color: hexToColor(ZainpayViewUtils.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCardPayment() async {
    if (mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CardPayment(
            context: widget.context,
            request: widget.standardRequest,
          ),
        ),
      );
      
      if (mounted && result != null) {
        Navigator.pop(context, result);
      }
    }
  }

  Future<void> _handleBankTransfer() async {
    if (mounted) {
      final createVARequest = CreateVirtualAccountRequest(
        publicKey: widget.standardRequest.publicKey,
        email: widget.standardRequest.email,
        mobileNumber: widget.standardRequest.mobileNumber,
        zainboxCode: widget.standardRequest.zainboxCode,
        fullName: widget.standardRequest.fullName,
        isTest: widget.standardRequest.isTest,
      );
      
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => BankTransferPayment(
            context: context,
            amount: double.parse(widget.standardRequest.amount),
            request: createVARequest,
          ),
        ),
      );
      
      if (mounted && result != null) {
        Navigator.pop(context, result);
      }
    }
  }

  Future<InitPaymentResponse?> startTransaction(StandardRequest request) async {
    return await request.initializePayment(request.publicKey);
  }
}
