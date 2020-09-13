import 'dart:async';

import 'package:chef_post/Widgets/Const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chef_post/Widgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/Const.dart';
import 'home.dart';
class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;//Shared prefernces to get data. It is like an internal db

  bool isLoading = false;//To see if a long backend process is going on. If yes, pause screen and show loading widget
  bool isLoggedIn = false;//To see if he is logged in
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();//Check to see if he is logged in already. If yes, go to home page
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;//Setting loading on since
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();//Method to check if signied in. Takes time
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),//Going to Home Page if logged in
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();//Getting instance

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();//Signing in
    GoogleSignInAuthentication googleAuth = await googleUser.authentication; //Authenticating

    final AuthCredential credential = GoogleAuthProvider.getCredential(//Getting information
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;//Signing into firebase

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
      await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();//Creating user if he does not exist
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'name': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'points':0,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('name', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
        await prefs.setInt('points',0);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('name', documents[0]['name']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);//Setting data in internal db
        await prefs.setInt('points', documents[0]['points']);
      }
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:primaryColor,
        appBar: AppBar(
          backgroundColor: themeColor,
          title: Text(
            "Login",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'SIGN IN WITH GOOGLE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: secondaryColor,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            ),
          ],
        ));
  }
}