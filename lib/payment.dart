import 'dart:convert';
import 'package:ayeautoo/user_Home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: RazorpayPayment(),
  ));
}

class RazorpayPayment extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RazorpayPayment(),
    );
  }
  _RazorpayPaymentState createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // JS interop logic should be safely isolated for web builds
    } else {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessMobile);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  @override
  void dispose() {
    _razorpay?.clear(); // Only clear if initialized
    super.dispose();
  }

  void _openPayment() {
    if (kIsWeb) {
      _openRazorpayWeb(); // Web Payment
    } else {
      _openRazorpayMobile(); // Android/iOS Payment
    }
  }

  // ✅ Razorpay for Android/iOS
  void _openRazorpayMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? amount = prefs.getString("amount"); // Retrieve the amount dynamically

    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe',
      'amount': (int.tryParse(amount ?? "0") ?? 0) * 100, // Convert amount to paise
      'name': 'Easy Tank',
      'description': 'Fuel Purchase',
      'theme': {'color': '#008000'},
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  // ✅ Placeholder for Web Payment to keep Android native clean
  void _openRazorpayWeb() async {
    print("Razorpay Web trigger called.");
  }

  // Mobile Success Handler (matches PaymentSuccessResponse signature)
  Future<void> _handlePaymentSuccessMobile(PaymentSuccessResponse response) async {
    await _processBackendPayment(response.paymentId);
  }

  // Shared Backend Payment Request
  Future<void> _processBackendPayment(String? paymentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString("url");
    String? sid = prefs.getString("rid");
    String? amount = prefs.getString("amount");

    if (url == null) {
      print("Error: Base URL is null in SharedPreferences");
      return;
    }

    try {
      var data = await http.post(
        Uri.parse("$url/make_payment"),
        body: {"rid": sid ?? "", "amount": amount ?? "0"},
      );

      var jsondata = json.decode(data.body);

      if (jsondata["res"] == "false") {
        print("Error in Payment");
      } else {
        if (jsondata["status"] == "ok") {
          print("Payment successful");
          if (mounted) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => userhome()));
          }
        } else {
          print("Payment failed");
        }
      }
    } catch (e) {
      print("Network error processing backend payment: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Used: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Razorpay Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: _openPayment,
          child: Text("Pay with Razorpay"),
        ),
      ),
    );
  }
}