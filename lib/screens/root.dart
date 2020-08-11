import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_project/screens/customer/home.dart';
import 'package:water_project/screens/vendor/homeVendor.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool vendor;
  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> setVendor() async {
    String uid = await getCurrentUser();
    Firestore.instance.collection('profiles').document(uid).get().then((value) {
      if (value.data['isVendor'] == true) {
        if (this.mounted) {
          setState(() {
            vendor = true;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            vendor = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    setVendor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (vendor == true) {
      return HomeVendor();
    } else if (vendor == false) {
      return Home();
    } else {
      return Scaffold();
    }
  }
}
