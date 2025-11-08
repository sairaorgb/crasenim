import 'dart:convert';
import 'dart:math';

import 'package:crasenimpharma/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

enum SendingStatus { notSent, sending, sentSuccess, sentReject }

class VerificationPagePage extends StatefulWidget {
  const VerificationPagePage({super.key});

  @override
  State<VerificationPagePage> createState() => _VerificationPagePageState();
}

class _VerificationPagePageState extends State<VerificationPagePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  Enum _sending = SendingStatus.notSent;
  String _generatedOTP = '';
  String _hintText = "Enter User name";
  var box;

  final List<String> usernameList = [
    'vizianagaram',
    'srikakulam-1',
    'srikakulam-2',
    'vizag-1',
    'vizag-2',
    'palasa',
    'bobbili',
    'anakapalli',
    'gajuwaka',
    'narsipatnam',
    'rajam',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  int generate6DigitInt() {
    Random rng;
    try {
      rng = Random.secure();
    } catch (_) {
      rng = Random();
    }
    return 100000 + rng.nextInt(900000); // 0..899999 -> plus 100000
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!validateInput()) {
      setState(() {
        _usernameController.clear();
        _hintText = "Username not found";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFFDF6FA),
          duration: Duration(seconds: 2),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Username not found, correct it and try again",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      return;
    }
    setState(() => _sending = SendingStatus.sending);
    dynamic responseText = SendingStatus.notSent;

    try {
      _generatedOTP = generate6DigitInt().toString();
      // _generatedOTP = '999999';
      responseText = await makeTwilioCall(
        toNumber: dotenv.env['toNumber']!,
        messageUrl: dotenv.env['messageUrl']!,
        username: _usernameController.text,
        otpString: _generatedOTP,
      );

      if (responseText == SendingStatus.sentSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFFDF6FA),
            duration: Duration(seconds: 2),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "OTP is sent to Admin, Contact Admin",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        _usernameController.clear();
        setState(() {
          _sending = SendingStatus.sentSuccess;
          _hintText = "Enter OTP";
        });
      } else {
        _usernameController.clear();
        setState(() {
          _sending = SendingStatus.notSent;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFFDF6FA),
            duration: Duration(seconds: 2),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Network Error Encountered",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFFDF6FA),
          duration: Duration(seconds: 2),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: $e',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<Enum> makeTwilioCall({
    required String toNumber,
    required String messageUrl,
    required String username,
    required String otpString,
  }) async {
    String accountSid = dotenv.env['accountSid']!;
    String authToken = dotenv.env['authToken']!;
    String fromNumber = dotenv.env['fromNumber']!;

    final uri = Uri.parse(dotenv.env['twillioUrl']!);

    // Basic Auth header
    final authHeader =
        'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}';

    final response = await http.post(
      uri,
      headers: {
        'Authorization': authHeader,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'To': '+919133025609',
        'From': fromNumber,
        'Body': "OTP generated for $username is $otpString",
      },
    );

    if (response.statusCode == 201) {
      return SendingStatus.sentSuccess;
    } else {
      return SendingStatus.sentReject;
    }
  }

  void _confirmOTP() {
    if (_otpController.text == _generatedOTP) {
      _otpController.clear();
      box.put("creds", true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      _otpController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFFDF6FA),
          duration: Duration(seconds: 1),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "OTP is not correct, Please try again",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      setState(() {
        _hintText = "Enter OTP";
        _sending = SendingStatus.sentSuccess;
      });
    }
  }

  bool validateInput() {
    var userInput = _usernameController.text;
    userInput = userInput.toLowerCase();
    if (usernameList.contains(userInput)) {
      return true;
    } else {
      return false;
    }
  }

  void initState() {
    super.initState();
    box = Hive.box('myBox');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final containerWidth = w > 900 ? 520.0 : w * 0.85;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFBF6FB), Color(0xFFFDF6FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: containerWidth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 36,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFE8DDE6),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // big friendly header
                        Column(
                          children: const [
                            Text(
                              'Welcome back',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2B2B2B),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Sign in to request OTP from admin',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6F6B72),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),

                        // form with nicer textfield
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Focus(
                                child: Builder(
                                  builder: (context) {
                                    final hasFocus = (Focus.of(
                                      context,
                                    ).hasFocus);
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      curve: Curves.easeOut,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: hasFocus
                                            ? [
                                                BoxShadow(
                                                  color: Colors.blue
                                                      .withOpacity(0.14),
                                                  blurRadius: 18,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: TextFormField(
                                        controller:
                                            (_sending ==
                                                    SendingStatus.notSent ||
                                                _sending ==
                                                    SendingStatus.sending)
                                            ? _usernameController
                                            : _otpController,
                                        textInputAction: TextInputAction.done,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            if (_sending ==
                                                    SendingStatus.notSent ||
                                                _sending ==
                                                    SendingStatus.sending)
                                              return 'Please enter username';
                                            else
                                              return 'Please enter OTP';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: _hintText,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 18,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFBDB3BB),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF4EA0F8),
                                              width: 1.6,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 28),

                              // gradient pill button
                              InkWell(
                                borderRadius: BorderRadius.circular(36),
                                onTap: _sending == SendingStatus.notSent
                                    ? _sendOtp
                                    : _sending == SendingStatus.sentSuccess
                                    ? _confirmOTP
                                    : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 54,
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                    maxWidth: 260,
                                    minWidth: 180,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: _sending == "sending"
                                        ? LinearGradient(
                                            colors: [
                                              Colors.blue.shade200,
                                              Colors.blue.shade100,
                                            ],
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xFF2FA1F6),
                                              Color(0xFF1E90FF),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                    borderRadius: BorderRadius.circular(36),
                                    boxShadow: _sending == "notSent"
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF1E90FF,
                                              ).withOpacity(0.28),
                                              blurRadius: 18,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: _sending == SendingStatus.sending
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                'Sending...',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          )
                                        : (_sending ==
                                              SendingStatus.sentSuccess)
                                        ? Text(
                                            'Confirm OTP',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              letterSpacing: 0.2,
                                            ),
                                          )
                                        : Text(
                                            'Send OTP to Admin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
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
