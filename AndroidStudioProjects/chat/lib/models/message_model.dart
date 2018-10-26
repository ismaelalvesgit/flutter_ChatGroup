import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends Model{

  bool isLogging = false;


  Firestore _db = Firestore.instance;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  static MessageModel of(BuildContext context)=>
      ScopedModel.of<MessageModel>(context);

   String roomId(String uid1, String uid2 ){
    String roomID;
    if( uid1.hashCode > uid2.hashCode){
      notifyListeners();
      roomID = "$uid1$uid2";
    }else{
      notifyListeners();
      roomID = "$uid2$uid1";
    }
    notifyListeners();
    print(roomID);
    return roomID;

   }

  void sendMessage( String msg, String email, String room){

     _db.collection("chat").document(room).collection("messagem").add({
       "msg":msg,
       "email":email,
       "date":DateTime.now()
     });
  }
}