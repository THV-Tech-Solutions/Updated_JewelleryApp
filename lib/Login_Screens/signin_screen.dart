import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/HelperFunctions/Toast.dart';
import 'package:jewellery/Login_Screens/userDetailsScreen.dart';
import 'package:jewellery/Screens/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  bool showOTPField = false; // Initially hide OTP field
  String _verificationId = '';
  bool isLoading = false;
  bool otpSent = false;

  Future<void> checkUserExistOrNot(String userPhoneNumber) async {
    try {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot = await usersCollection
          .where('userPhoneNumber', isEqualTo: userPhoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        String userPhoneNumber = document['userPhoneNumber'];
        String userName = document['userName'];
        String userCity = document['userCity'];
        String userEmail = document['userEmail'];
        String Admin = document['Admin'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userPhoneNumber', userPhoneNumber);
        await prefs.setString('userEmail', userEmail);
        await prefs.setString('userName', userName);
        await prefs.setString('userCity', userCity);
        await prefs.setString('Admin', Admin);

        Get.offAll(const TabsScreen());
        setState(() {
          isLoading = false;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => userDetailsScreen(
              userPhoneNumber_: userPhoneNumber,
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.toast_("Error : ${e.toString()}");
    }
  }

  Future<void> loginWithPhone() async {
    String PhoneNumber = formatPhoneNumber(_phoneNumberCtrl.text);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: PhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException authException) {
          setState(() {
            isLoading = false;
          });
          ToastMessage.toast_(
              "Phone verification failed. Code: ${authException.code}");
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          _verificationId = verificationId;
          if (_verificationId.isNotEmpty) {
            setState(() {
              otpSent = true;
              isLoading = false;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.toast_(e.toString());
    }
  }

  Future<void> verifyOTP(String otp) async {
    String PhoneNumber = formatPhoneNumber(_phoneNumberCtrl.text);

    try {
      if (_verificationId.isNotEmpty) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: otp,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          await checkUserExistOrNot(PhoneNumber);
        } else {
          setState(() {
            isLoading = false;
          });
          ToastMessage.toast_("InCorrect OTP!");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ToastMessage.toast_(
            "Oops!. Sending the OTP failed. Please try after some time.");
      }
    } catch (e) {
      ToastMessage.toast_("Error verifying OTP: ${e.toString()}");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (!phoneNumber.startsWith('91')) {
      phoneNumber = '91$phoneNumber';
    }

    if (phoneNumber.length == 10 && phoneNumber.startsWith('91')) {
      phoneNumber = '91$phoneNumber';
    }

    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+$phoneNumber';
    }
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(139, 96, 67, 6)
                ], // Black to Gold gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
        height: double.infinity, // Ensure background color covers the full screen
        
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width > 600 ? 50 : 25),
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                Center(
                  child: Container(
                    width: width > 600 ? 200 : 150,
                    height: width > 600 ? 200 : 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.5),
                          spreadRadius: 10,
                          blurRadius: 20,
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                Card(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width > 600 ? 40 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Verification",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.marcellusSc(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        _buildTextFormField(
                          labelText: "Enter Phone Number",
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberCtrl,
                        ),
                        if (otpSent)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: _buildTextFormField(
                              labelText: "Enter OTP",
                              prefixIcon: Icons.security,
                              keyboardType: TextInputType.number,
                              controller: _otpCtrl,
                            ),
                          ),
                        SizedBox(height: height * 0.03),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(175, 251, 146, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: height > 600 ? 18 : 15,
                              horizontal: width > 600 ? 80 : 50,
                            ),
                            shadowColor: Colors.orange.withOpacity(0.6),
                            elevation: 10,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  otpSent ? "Verify OTP" : "Send OTP",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                          onPressed: () {
                            if (otpSent) {
                              if (_otpCtrl.text.length == 6) {
                                setState(() {
                                  isLoading = true;
                                });
                                verifyOTP(_otpCtrl.text);
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Enter a valid OTP",
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              loginWithPhone();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          labelStyle: TextStyle(color: Colors.white60), // Light label color
          fillColor: const Color.fromARGB(255, 6, 6, 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: Colors.orangeAccent),
        ),
      ),
    );
  }
}
