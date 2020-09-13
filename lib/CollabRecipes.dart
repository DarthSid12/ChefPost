
import 'package:chef_post/AddOnRecipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/Const.dart';
import 'Widgets/Drawer.dart';

class CollabRecipes extends StatefulWidget {
  @override
  _CollabRecipesState createState() => _CollabRecipesState();
}

class _CollabRecipesState extends State<CollabRecipes> {
  String id = "";
  SharedPreferences prefs;
  void setData() async{
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    id2 = id;
    setState(() {
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
        title: Text("Collaborate on recipes"),
        backgroundColor:Colors.pink
      ),
      drawer: makeDrawer(context,"Collab On Recipe"),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage("https://static.vecteezy.com/system/resources/previews/000/581/156/original/banana-pop-art-vector-background.png")
          )
        ),
        child: StreamBuilder(
          stream:     Firestore.instance.collection("Recipe").where("finalized",isEqualTo: "false").snapshots(),
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
                    return makeItem(documents, index);
                  }
              );
            }
          },
        ),
      ),
    );
  }

}
String id2;
class makeItem extends StatefulWidget {
  List documents;
  int index;
  makeItem(this.documents,this.index);
  @override
  _makeItemState createState() => _makeItemState(documents,index);
}

class _makeItemState extends State<makeItem> {
  List documents;
  int index;
  bool isMine = false;
  _makeItemState(this.documents,this.index);
  void setData() async{
    getCollection(documents[index]).then((value) {
      isMine = value;
      setState(() {
      });
    });
  }
  Future<bool> getCollection(DocumentSnapshot document) async {
    QuerySnapshot collaborators =await document.reference.collection("collaborators").getDocuments();
    if (document['started-by'].toString().split("/")[1] == id2){
      return true;
    }
    for (DocumentSnapshot documentSnapshot in collaborators.documents){
      print(documentSnapshot['name'].toString().split("/")[1]);
      if (documentSnapshot['name'].toString().split("/")[1] == id2){
        return true;
      }
    }
    return false;
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
              builder: (context) => Collaborate(documents[index],isMine)));
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
                    Text(documents[index]['dish'],
                        maxLines: null
                        ,style:TextStyle(
                            color: primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        )),
                    SizedBox(height:10),
                    Text(isMine?"ALREADY COLLABED":"OPEN FOR COLLAB",
                        maxLines: null
                        ,style:TextStyle(
                            fontSize: 15,
                            color: subColor
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

