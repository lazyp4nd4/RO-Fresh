import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_project/auth/login%20attempt.dart';
import 'package:water_project/screens/root.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/services/database.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String phoneNo;
  String smsOTP;
  String name;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            final AuthResult result =
                await _auth.signInWithCredential(phoneAuthCredential);
            final FirebaseUser user = result.user;
            final FirebaseUser currentUser = await _auth.currentUser();
            assert(user.uid == currentUser.uid);
            String uid = currentUser.uid;
            String phoneNumber = currentUser.phoneNumber;
            String name = this.name;
            DatabaseServices().addData(uid, phoneNumber, name);
            // Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Root(),
                ));
            //print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            //print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Root(),
                          ));
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      String uid = currentUser.uid;
      String phoneNumber = currentUser.phoneNumber;
      String name = this.name;
      DatabaseServices().addData(uid, phoneNumber, name);
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Root(),
          ));
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Constants.BUTTON_TXT),
      home: Scaffold(
        body: Center(
          child: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'REGISTER',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Constants.BUTTON_TXT),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Name: ',
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey[400]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: true,
                    decoration: InputDecoration(
                      fillColor: Constants.BUTTON_BG,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Constants.BUTTON_TXT,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Constants.BUTTON_TXT)),
                      hintText: 'Name',
                      focusColor: Constants.BUTTON_TXT,
                    ),
                    onChanged: (value) {
                      this.name = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Phone Number: ',
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey[400]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    enabled: true,
                    decoration: InputDecoration(
                      fillColor: Constants.BUTTON_BG,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Constants.BUTTON_TXT,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Constants.BUTTON_TXT)),
                      hintText: 'Phone Number',
                      focusColor: Constants.BUTTON_TXT,
                    ),
                    onChanged: (value) {
                      this.phoneNo = '+91' + value;
                    },
                  ),
                  (errorMessage != ''
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.left,
                        )
                      : Container()),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    onPressed: () {
                      verifyPhone();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Constants.BUTTON_TXT,
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginAttempt(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 16, color: Constants.BUTTON_TXT),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
