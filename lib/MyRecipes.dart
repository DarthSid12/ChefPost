import 'package:chef_post/Finalize.dart';
import 'package:chef_post/Widgets/Drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddOnRecipe.dart';
import 'Recipe.dart';
import 'Widgets/Const.dart';

class MyRecipes extends StatefulWidget {
  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  String id = "";
  SharedPreferences prefs;
  List<Widget> widgetList = [

  ];
  void setData() async{
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    id2 = id;
    setState(() {
      widgetList = [
        SizedBox(height: MediaQuery.of(context).size.height*0.42,),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: MediaQuery.of(context).size.height*0.42,),
      ];
      makeWidgetList();
    });
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
        title: Text("My Recipes"),
        backgroundColor: Colors.pink,
      ),
      drawer: makeDrawer(context,"My Recipes"),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration:BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.pinimg.com/originals/6f/4a/86/6f4a869f0daa1031e1a244b1c7e2b471.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetList,
          ),
        ),
      ),
    );
  }
  void makeWidgetList() async {
    DocumentReference reference = Firestore.instance.collection("users").document(id);
    DocumentSnapshot snapshot = await reference.get();
    List recipes = snapshot['recipes'];
    QuerySnapshot validRecipes = await Firestore.instance.collection("Recipe").where(FieldPath.documentId,whereIn: recipes).getDocuments();
    widgetList = [];
    for (DocumentSnapshot documentSnapshot in validRecipes.documents){
      widgetList.add(SizedBox(height: 12,));
      widgetList.add(documentSnapshot['finalized'] == "false"?makeItem2(documentSnapshot):Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Recipe(documentSnapshot)));
          },
          child: Container(
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            height: MediaQuery.of(context).size.height *0.23,
            width: MediaQuery.of(context).size.width *0.92,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius:MediaQuery.of(context).size.height *0.1,
                  backgroundImage: NetworkImage(
                      documentSnapshot['photo'] == null?"":documentSnapshot['photo']
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(documentSnapshot['dish'],
                          maxLines: null
                          ,style:TextStyle(
                              color: primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic
                          )),
                      SizedBox(height:10),
                      Row(
                        children: [
                          Icon(Icons.timer, color: subColor, size: 14,),
                          Text("Cooking time:",
                              maxLines: null
                              ,style:TextStyle(
                                  fontSize: 15,
                                  color: subColor
                              )),
                          Text(documentSnapshot['cookingTime'].toString(),
                              maxLines: null
                              ,style:TextStyle(
                                  fontSize: 15,
                                  color: subColor
                              )),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ));
    }
    setState(() {

    });
  }
}
String id2;
class makeItem2 extends StatefulWidget {
  DocumentSnapshot document;
  makeItem2(this.document);
  @override
  _makeItemState createState() => _makeItemState(document);
}

class _makeItemState extends State<makeItem2> {
  DocumentSnapshot document;
    String isMine = "nope";
  _makeItemState(this.document);
  void setData() async{
    getCollection(document).then((value) {
      isMine = value;
      setState(() {
      });
    });
  }
  Future<String> getCollection(DocumentSnapshot document) async {
    QuerySnapshot collaborators =await document.reference.collection("collaborators").getDocuments();
    if (document['started-by'].toString().split("/")[1] == id2){
      return "my";
    }
    for (DocumentSnapshot documentSnapshot in collaborators.documents){
      print(documentSnapshot['name'].toString().split("/")[1]);
      if (documentSnapshot['name'].toString().split("/")[1] == id2){
        return "part";
      }
    }
    return "nope";
  }
  @override
  void initState(){
    super.initState();
    setData();
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Collaborate(document,true)));
        },
        child: Container(
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          height: MediaQuery.of(context).size.height *0.12,
          width: MediaQuery.of(context).size.width *0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(document['dish'],
                        maxLines: null
                        ,style:TextStyle(
                            color: primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        )),
                    SizedBox(height:10),
                    Text("ALREADY COLLABED",
                        maxLines: null
                        ,style:TextStyle(
                            fontSize: 15,
                            color: subColor
                        ))
                  ],
                ),
              ),
              SizedBox(width: 30,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Finalize(document)));
                    },
                    child: Text("FINALIZE",style: TextStyle(
                      color: Colors.orange,
                      fontSize: 22
                    ),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
