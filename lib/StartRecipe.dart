import 'package:chef_post/MyRecipes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/Drawer.dart';
class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  String dish = "";
  String id = "";
  String ingredient1 = "";
  String ingredient2 = "";
  String ingredient3 = "";
  String step = "";
  SharedPreferences prefs;
  void setData() async{
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
  }
  @override
  void initState(){
    super.initState();
    setData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start A Recipe"),
        backgroundColor: Colors.pink,
      ),
      drawer: makeDrawer(context,"Start A Recipe"),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit:BoxFit.cover,
            image: NetworkImage("https://i.pinimg.com/originals/06/29/21/06292175121f1f49f8a07e54cb38c23d.jpg")
          )
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.8,
            width: MediaQuery.of(context).size.width*0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            border:Border.all(color: Colors.black,width: 4)
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Text("DISH",style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),),
                SizedBox(height: 5,),
                Form(
                  child: TextFormField(
                    style: TextStyle(
                        color:Colors.pink,
                        fontSize: 18,
                        fontStyle: FontStyle.italic
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      dish = text;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Like chocolate cake',
                        hintStyle: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text("FIRST INGREDIENT",style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),),
                SizedBox(height: 5,),
                Form(
                  child: TextFormField(
                    style: TextStyle(
                        color:Colors.pink,
                        fontSize: 18,
                        fontStyle: FontStyle.italic
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      ingredient1 = text;
                    },
                    decoration: const InputDecoration(
                        hintText: 'First Ingredient',
                        hintStyle: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text("SECOND INGREDIENT",style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),),
                SizedBox(height: 5,),
                Form(
                  child: TextFormField(
                    style: TextStyle(
                        color:Colors.pink,
                        fontSize: 18,
                        fontStyle: FontStyle.italic
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      ingredient2 = text;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Second Ingredient',
                        hintStyle: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text("THIRD INGREDIENT",style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),),
                SizedBox(height: 5,),
                Form(
                  child: TextFormField(
                    style: TextStyle(
                        color:Colors.pink,
                        fontSize: 18,
                        fontStyle: FontStyle.italic
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      ingredient3 = text;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Third Ingredient',
                        hintStyle: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text("FIRST STEP",style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
                SizedBox(height: 5,),
                Form(
                  child: TextFormField(
                    style: TextStyle(
                        color:Colors.pink,
                        fontSize: 18,
                        fontStyle: FontStyle.italic
                    ),
                    keyboardType: TextInputType.multiline,
                    onChanged: (text) {
                      step = text;
                    },
                    decoration: const InputDecoration(
                        hintText: 'First step',
                        hintStyle: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RaisedButton(
                        onPressed: () async{
                          DocumentReference reference = await Firestore.instance.collection("Recipe").add({
                            "ingredient1":ingredient1,
                            "ingredient2":ingredient2,
                            "ingredient3":ingredient3,
                            "step":step,
                            "dish":dish,
                            "liked-by":[],
                            "started-by":"users/"+id.toString(),
                            "likes":0,
                            "finalized":"false",
                            "cookingTime":0,
                            "photo":"",
                          });
                          Firestore.instance.collection("users").document(id).updateData({
                            "recipes": FieldValue.arrayUnion([reference])
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => MyRecipes()));
                        },
                        child:Text("SUBMIT",style:TextStyle(
                          color: Colors.black,
                          letterSpacing: 4,
                          fontSize: 20
                        ))
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        )
      ),
    );
  }
}
