import 'package:chef_post/Community.dart';
import 'package:chef_post/LoginPage.dart';
import 'package:chef_post/MyProfile.dart';
import 'package:chef_post/MyRecipes.dart';
import 'package:chef_post/StartRecipe.dart';
import 'package:chef_post/Widgets/Const.dart';
import 'package:chef_post/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../CollabRecipes.dart';

Container makeDrawer(context,page) {
  GoogleSignIn googleSignIn = GoogleSignIn();
  return Container(
    width: MediaQuery.of(context).size.width/1.5,
    height: MediaQuery.of(context).size.height,
    color: secondaryColor,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height:30),
          makeTile(Icon(Icons.home), context, "Home", page, Home()),
          makeTile(Icon(Icons.add), context, "Start A Recipe", page, AddRecipe()),
          makeTile(FaIcon(FontAwesomeIcons.utensils), context, "Collab on Recipe", page, CollabRecipes()),
          makeTile(FaIcon(FontAwesomeIcons.hatWizard), context, "Our Chefs", page, Community()),
          makeTile(FaIcon(FontAwesomeIcons.scroll), context, "My Recipes", page, MyRecipes()),
          makeTile(FaIcon(Icons.account_circle), context, "My Profile", page, Profile()),
         ListTile(
        leading: Icon(Icons.logout),
        title: Text("Log out"),
        onTap: () async {
            await FirebaseAuth.instance.signOut();
            await googleSignIn.disconnect();
            await googleSignIn.signOut();

            Navigator.of(context)
                .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()), (
                Route<dynamic> route) => false);

        },
      )
        ],
      ),
    ),
  );
}
Widget makeTile(icon,context,name,page,StatefulWidget statefulWidget){
  return name.toString().toLowerCase() == page.toLowerCase()?
  Container(
    color: selectedColor,
    child: ListTile(
      leading: icon,
      title: Text(name),
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => statefulWidget));
      },
    ),
  ):
  ListTile(
    leading: Container(child:icon),
    title: Text(name),
    onTap: () {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => statefulWidget));
    },
  );
}