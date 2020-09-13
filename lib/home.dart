import 'package:chef_post/Recipe.dart';
import 'package:chef_post/Widgets/Const.dart';
import 'package:chef_post/Widgets/Drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  String name = "";
  int points = 0;
  String id = "";
  List<Widget> widgetList = [
  ];

  @override
  void initState(){
    super.initState();
    setData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading:Builder(
          builder:(context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              }
          ),
        ),
        title: Text(
          "Home",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: makeDrawer(context,"Home"),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage("https://img.freepik.com/free-photo/citrus-fruit-circles-yellow-background_23-2148145072.jpg?size=626&ext=jpg")
          )
        ),
        child: StreamBuilder(
          stream:     Firestore.instance.collection("Recipe").where("finalized",isEqualTo: "true").orderBy("likes",descending: true).snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              );
            }
            else {
              List<DocumentSnapshot> documents = snapshot.data.documents;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder:(context,index){
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(
                           builder: (context) => Recipe(documents[index])));
                     },
                     child: Container(
                       decoration: BoxDecoration(
                         color: secondaryColor,
                         borderRadius: BorderRadius.all(Radius.circular(12))
                       ),
                        height: MediaQuery.of(context).size.height *0.23,
                        width: MediaQuery.of(context).size.width *0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius:MediaQuery.of(context).size.height *0.1,
                              backgroundImage: NetworkImage(
                                  documents[index]['photo'] == null?"":documents[index]['photo']
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(documents[index]['dish'],
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
                                      Text(documents[index]['cookingTime'].toString(),
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
                 );
                }
              );
            }
          },
        ),
      )
    );
  }
  void setData() async{
     prefs = await SharedPreferences.getInstance();
     name = prefs.getString("name");
     points = prefs.getInt("points");
     id = prefs.getString("id");
     setState(() {
     });
}
}
