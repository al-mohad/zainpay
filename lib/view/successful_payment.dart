import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zainpay/utils/zainpay_view_utils.dart';

import '../models/response/payment_response.dart';

/// A widget that displays a successful payment screen
class SuccessfulPayment extends StatefulWidget {
  final dynamic request;
  final PaymentResponse paymentResponse;
  final BuildContext context;

  const SuccessfulPayment({
    super.key,
    required this.request,
    required this.paymentResponse,
    required this.context,
  });

  @override
  SuccessfulPaymentState createState() => SuccessfulPaymentState();
}

class SuccessfulPaymentState extends State<SuccessfulPayment> {
  bool _isRedirecting = false;

  @override
  void initState() {
    super.initState();
    _scheduleRedirect();
  }

  Future<void> _scheduleRedirect() async {
    setState(() {
      _isRedirecting = true;
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.pop(context, widget.paymentResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hexToColor = ZainpayViewUtils.hexToColor;
    final blackTextStyle = ZainpayViewUtils.blackTextStyle;
    final formatter = ZainpayViewUtils.formatter;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  // Success icon
                  Center(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexToColor(ZainpayViewUtils.paymentIconBlueBackgroundColor),
                      ),
                      child: Container(
                        height: 40.29,
                        width: 40.29,
                        margin: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hexToColor(ZainpayViewUtils.paymentBlueBackgroundColor),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.checkDouble,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Success message
                  Center(
                    child: Text(
                      'Transaction Successful',
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                        color: hexToColor(ZainpayViewUtils.blackColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Payment amount
                  Container(
                    width: 250,
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Payment of ',
                          style: blackTextStyle.copyWith(
                            color: hexToColor(ZainpayViewUtils.paymentTextColor),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: 'N${formatter.format(double.parse(widget.request.amount.toString()))}',
                              style: blackTextStyle.copyWith(
                                color: hexToColor(ZainpayViewUtils.paymentTextColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' is Successful',
                              style: blackTextStyle.copyWith(
                                color: hexToColor(ZainpayViewUtils.paymentTextColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Loading indicator
                  if (_isRedirecting)
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: .5,
                        color: hexToColor(ZainpayViewUtils.paymentBlueBackgroundColor),
                      ),
                    ),
                  const SizedBox(height: 40),
                  // Redirect message
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        'You will be redirected automatically, please wait',
                        textAlign: TextAlign.center,
                        style: blackTextStyle.copyWith(
                          color: hexToColor(ZainpayViewUtils.textGreyColor),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
