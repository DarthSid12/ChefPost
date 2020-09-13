import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
DocumentSnapshot snapshot;
bool isCollabed;
class Collaborate extends StatefulWidget {
  Collaborate(snapshots,collabed){
    snapshot =snapshots;
    isCollabed = collabed;
  }
  @override
  _CollaborateState createState() => _CollaborateState();
}

class _CollaborateState extends State<Collaborate> {
  List<Widget> widgetList = [];
  QuerySnapshot collaboratorS;
  SharedPreferences prefs;
  String id = "";
  List collaborato = [];
  bool liked = false;

  @override
  void initState() {
    super.initState();
    widgetList = [
    ];
    makeWidgetList();
    setData();
  }

  void setData() async {
    collaboratorS = await snapshot.reference.collection(
        "collaborators").getDocuments();
    var aList = collaboratorS.documents + [snapshot];
    for (DocumentSnapshot collaborator in aList) {
      DocumentReference something2 = await Firestore.instance.document(
          collaborator['name'] == null
              ? collaborator['started-by']
              : collaborator['name']);
      DocumentSnapshot something = await something2.get();
      collaborato.add(something);
    }
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collaborate On Recipe"),
        backgroundColor: Colors.pink,
      ),
      body:Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://images-na.ssl-images-amazon.com/images/I/617xo9VUFVL._AC_SY450_.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: widgetList,
          ),
        ),
      )
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
    List<String> steps = [snapshot['step']];
    print(snapshot['step']);
    List<String> names = [snapshot['name'].toString()];
    for (DocumentSnapshot collaborator in collaborators.documents) {
      ingredients.add(collaborator['ingredient']);
      steps.add(collaborator['step']);
      names.add(collaborator['name'].toString());
    }
    widgetList.add(
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Text(snapshot['dish'],style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),),
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
        width: MediaQuery
            .of(context)
            .size
            .width,
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
    for (String step in steps) {
      widgetList.add(Container(
        color: Colors.white,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("• " + step.toString(),
              maxLines: null,
              style: TextStyle(
                  color: Colors.pink,
                  fontStyle: FontStyle.italic
              )),
        ),
      ));
    }
    widgetList.add(SizedBox(height: 30,));
    widgetList.add(isCollabed?Container():RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.grey,
      onPressed: () async{
    String ingredient = "";
    String step = "";
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
    FontAwesomeIcons.utensils,
    size: 30.0,
    color: Colors.white,
    ),
    margin: EdgeInsets.only(bottom: 10.0),
    ),
    Text(
    'Collaborate',
    style: TextStyle(color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.bold),
    ),

    ],
    ),
    ),
    SimpleDialogOption(
    onPressed: () {
    Navigator.pop(context, 0);
    },
    child: Row(
    children: <Widget>[
    Container(
    height: MediaQuery.of(context).size.height*0.13,
    width: MediaQuery.of(context).size.width*0.65,
    child: Form(
    child: TextFormField(
    style: TextStyle(
    color:Colors.black,
    fontSize: 18,
    fontStyle: FontStyle.italic
    ),
    keyboardType: TextInputType.text,
    onChanged: (text) {
    ingredient = text;
    },
    decoration: const InputDecoration(
    hintText: 'Ingredient',
    hintStyle: TextStyle(
    color:Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    )
    ),
    ),
    )
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
    step = text;
    },
    decoration: const InputDecoration(
    hintText: 'Step to do',
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
    Navigator.pop(context, 1);
    print(1);
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
    if(step!=null && step!="" && ingredient!=null && ingredient !=""){
    DocumentReference reference =await snapshot.reference.collection("collaborators").add({
    "step":step,

    "ingredient":ingredient,
    "id":id,
    "reports":0
    });
    Firestore.instance.collection("users").document(id).updateData({
       "recipes": FieldValue.arrayUnion([reference])
    });
    isCollabed = true;
    setState(() {
    });
    makeWidgetList();
    setState(() {

    });
    }
      },
      child: Text("COLLABORATE",style: TextStyle(
          color: Colors.black,
          letterSpacing: 4,
          fontSize: 20
      )),));
    setState(() {});
  }
}
