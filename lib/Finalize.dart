import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'MyRecipes.dart';

DocumentSnapshot documentReference;
class Finalize extends StatefulWidget {
  Finalize(reference){
    documentReference = reference;
  }
  @override
  _FinalizeState createState() => _FinalizeState();
}

class _FinalizeState extends State<Finalize> {
  String cookingTime = "";
  String imageUrl = "";
  File imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finalize"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
          image:NetworkImage("https://i.pinimg.com/originals/26/16/df/2616dfad5257af685f28040a70f579db.jpg")
        ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Text("By finalizing this recipe, you agree that you have followed this recipe and have got results.",style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 30,),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height*0.5,
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
                        Text("COOKING TIME",style: TextStyle(
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
                              cookingTime = text;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Time taken without waiting time',
                                hintStyle: TextStyle(
                                  color:Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text("IMAGE",style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),),
                        SizedBox(height: 5,),
                        FlatButton(onPressed: (){
                          getImage();
                        }, child: Text("Select Image")),
                        SizedBox(height: 5,),
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
                                    await documentReference.reference.updateData({
                                      "finalized":"true",
                                      "cookingTime":cookingTime,
                                      "photo":imageUrl,
                                    });
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => MyRecipes()));
                                  },
                                  child:Text("FINALIZE",style:TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = image;
      });
      uploadFile(1);
    }
  }
  Future uploadFile(type) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
    });
  }
}
