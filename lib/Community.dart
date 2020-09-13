import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Widgets/Const.dart';
import 'Widgets/Drawer.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Our Chefs"),
          backgroundColor:Colors.pink
      ),
      drawer: makeDrawer(context,"Our Chefs"),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage("https://c.stocksy.com/a/9Ub500/z9/1335737.jpg")
          )
        ),
        child: StreamBuilder(
          stream:     Firestore.instance.collection("users").orderBy("points",descending: true).snapshots(),
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
                      child: Container(
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        height: MediaQuery.of(context).size.height *0.15,
                        width: MediaQuery.of(context).size.width *0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 20,),
                            Image(
                              image:  NetworkImage(
                                  documents[index]['photoUrl'] == null?"":documents[index]['photoUrl']
                              ),
                              height:  MediaQuery.of(context).size.height *0.1,
                              width:  MediaQuery.of(context).size.height *0.1,
                            ),
                            SizedBox(width: 20,),

                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Points: "+documents[index]['points'].toString(),
                                      maxLines: null
                                      ,style:TextStyle(
                                          fontSize: 18,
                                          color: subColor
                                      )),


                                  SizedBox(height:10),
                                  Text(documents[index]['name'],
                                      maxLines: null
                                      ,style:TextStyle(
                                          color: primaryColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic
                                      )),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
          },
        ),
      ),
    );
  }
}
