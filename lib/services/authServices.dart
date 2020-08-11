import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_project/auth/register.dart';
import 'package:water_project/screens/root.dart';
import 'package:water_project/services/database.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Root();
        } else {
          return Register();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  register(AuthCredential authCredential, name) async {
    AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    FirebaseUser user = authResult.user;
    String uid = user.uid;
    String phone = user.phoneNumber;
    DatabaseServices().addData(uid, phone, name);
    return user;
  }

  registerWithOtp(otp, verId, name) async {
    AuthCredential authCreds =
        PhoneAuthProvider.getCredential(verificationId: verId, smsCode: otp);
    FirebaseUser user = await register(authCreds, name);
    return user;
  }

  signIn(AuthCredential authCredential) async {
    AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    FirebaseUser user = authResult.user;
    print('${user.uid}');
    return user;
  }

  signInWithOtp(otp, verId) async {
    AuthCredential authCreds =
        PhoneAuthProvider.getCredential(verificationId: verId, smsCode: otp);
    FirebaseUser user = await signIn(authCreds);
    return user;
  }
}
