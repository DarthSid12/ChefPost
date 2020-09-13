import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


DocumentSnapshot snapshot;
class Recipe extends StatefulWidget {
  Recipe(DocumentSnapshot documentSnapshot){
    snapshot = documentSnapshot;
  }
  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  List<Widget> widgetList = [];
  QuerySnapshot collaboratorS;
  SharedPreferences prefs;
  String id = "";
  List collaborato = [];
  bool liked = false;
  List likedBy = [];
  @override
  void initState() {
    super.initState();
    widgetList = [
    ];
    likedBy = snapshot['liked-by'];
    makeWidgetList();
    setData();
  }
  void setData() async{
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    for (String person in likedBy){
      if (person==id){
        liked = true;
        break;
      }
      else{
        liked = false;
      }
    }
    print (id);
    print (likedBy.toString());
    print(liked.toString());
    setState(() {

    });
    collaboratorS = await snapshot.reference.collection(
        "collaborators").getDocuments();
    var aList = collaboratorS.documents + [snapshot];
    for (DocumentSnapshot collaborator in aList){
        DocumentReference something2 = Firestore.instance.document(collaborator['name'] == null?collaborator['started-by']:collaborator['name']);
        DocumentSnapshot something = await something2.get();
      collaborato.add(something);
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(snapshot['dish']),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon:Icon(Icons.favorite),
            color: liked?Colors.blue:Colors.white,
            onPressed: () async {
              liked = !liked;
              snapshot.reference.updateData({
                "likes": liked?FieldValue.increment(1):FieldValue.increment(-1),
                "liked-by": liked?FieldValue.arrayUnion([id]):FieldValue.arrayRemove([id])
              });
              for (DocumentSnapshot collaborator in collaborato){
                collaborator.reference.updateData({
                  "points": liked?FieldValue.increment(10):FieldValue.increment(-10)
                });
              }

              setState(() {
              });
            },
          ),
          SizedBox(width: 40,)
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage("https://m.media-amazon.com/images/I/61vITKyJbLL._AC_SS350_.jpg")
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
    QuerySnapshot collaborators = await snapshot.reference.collection(
        "collaborators").getDocuments();
    List<String> ingredients = [
      snapshot['ingredient1'],
      snapshot['ingredient2'],
      snapshot['ingredient3']
    ];
    List steps = [snapshot];
    List<String> names = [snapshot['name'].toString()];
    for (DocumentSnapshot collaborator in collaborators.documents) {
      ingredients.add(collaborator['ingredient']);
      steps.add(collaborator);
      names.add(collaborator['name'].toString());
    }
    widgetList.add(
      Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Image(
          fit: BoxFit.cover,
          image: NetworkImage(snapshot['photo']),
        ),
      )
    );
    widgetList.add(SizedBox(height: 30));
    widgetList.add(Container(
      child: Center(
        child: Text("Ingredients", style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
    ));
    widgetList.add(SizedBox(height: 30,));
    for (String ingredient in ingredients) {
      widgetList.add(Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text("• " + ingredient, style: TextStyle(
                color: Colors.pink
            )),
          ),
        ),
      ));
      }

    setState(() {});
    widgetList.add(SizedBox(height: 30,));
    widgetList.add(Container(
      child: Center(
        child: Text("Steps", style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
    ));
    widgetList.add(SizedBox(height: 30,));
    for (DocumentSnapshot step in steps) {
      bool clicked = false;
      widgetList.add(Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text:
              TextSpan(
              children:[
                // WidgetSpan(
                //   child: IconButton(
                //     icon: FaIcon(
                //         FontAwesomeIcons.bullhorn,
                //       color: clicked?Colors.orange:Colors.grey,
                //       size: 20,
                //     ),
                //     onPressed: (){
                //       step.reference.updateData({
                //         "reports":clicked?FieldValue.increment(1):FieldValue.increment(-1),
                //       });
                //     },
                //   )
                // )
                // ,
                  TextSpan(
                  text:"• " + step['step'],
            style: TextStyle(
              color: Colors.pink,
              fontStyle: FontStyle.italic
          )
              )]
          ),
          )
        ),
      ));
    }
    setState(() {
    });
    QuerySnapshot comments = await snapshot.reference.collection(
        "comments").getDocuments();
    widgetList.add(SizedBox(height: 20,));
    widgetList.add(Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Comments", style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          ),
          SizedBox(width:20),
          RawMaterialButton(
            fillColor: Colors.pink,
            shape: CircleBorder(),
              child:Icon(Icons.add,
              color: Colors.black,
              size: 22,),
              onPressed: () async{
                String comment;
                await showDialog(context: context,
                    builder:(_){
                  return Container(
                    child: SimpleDialog(
                      contentPadding: EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                      children: <Widget>[
                        Container(
                          color:Color(0xfff5a623),
                          margin: EdgeInsets.all(0.0),
                          padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                          height: 100.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: FaIcon(
                                  FontAwesomeIcons.comment,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(bottom: 10.0),
                              ),
                              Text(
                                'Comment',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),

                            ],
                          ),
                        ),
                        SimpleDialogOption(
                          child: Container(
                              height: MediaQuery.of(context).size.height*0.13,
                              width: MediaQuery.of(context).size.width*0.65,
                              child: Form(
                                child: TextFormField(
                                  style: TextStyle(
                                      color:Colors.black,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (text) {
                                    comment = text;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'Your comment...',
                                      hintStyle: TextStyle(
                                        color:Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ),
                              )
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            snapshot.reference.collection("comments").add({
                              "comment":comment,
                              "name":"users/"+id,
                              // "id":FieldPath.documentId
                            });
                            print("Added");
                            Navigator.pop(context, 1);
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xff203152),
                                ),
                                margin: EdgeInsets.only(right: 10.0),
                              ),
                              Text(
                                'Add',
                                style: TextStyle(
                                    color: Color(0xff203152), fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
                makeWidgetList();
                setState(() {
                });
              })
        ],
      ),
    ));
    widgetList.add(SizedBox(height:30));
    for (DocumentSnapshot comment in comments.documents) {
      DocumentSnapshot user = await Firestore.instance.document(comment['name'].toString()).get();
      widgetList.add(SizedBox(height:20));
      widgetList.add(Row(
         children: [
           Image(image: NetworkImage(user['photoUrl'].toString()),
           height: 30,
           width: 30,),
             Text(user['name'].toString(),style: TextStyle(
               color: Colors.black,
               fontWeight: FontWeight.bold,
               fontSize: 16
             ),),

         ],
      ));
      widgetList.add(SizedBox(height:5));
      widgetList.add(Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text(comment['comment'], style: TextStyle(
                color: Colors.pink
            )),
          ),
        ),
      ));
    }
    setState(() {

    });
  }
}
