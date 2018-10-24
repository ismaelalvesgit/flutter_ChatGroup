import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;

  Firestore _db = Firestore.instance;

  FirebaseUser currentUser;

  bool isLogging = false;

  Map<String, dynamic> userData = Map();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

   void singIn(String email, String pass, VoidCallback onSuccess, VoidCallback onFail) async{

     isLogging = true;
     notifyListeners();
     await _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) async{

       isLogging = false;
       notifyListeners();
       currentUser = user;
       await _loadCurrentUser();
       onSuccess();
     }).catchError((e){

       isLogging = false;
       notifyListeners();
       onFail();
     });

   }

   void singOut(VoidCallback onSuccess, VoidCallback onFail) async{
     isLogging = true;
     notifyListeners();
     await _auth.signOut().then((s){
       isLogging = false;
       currentUser = null;
       notifyListeners();
       onSuccess();
     }).catchError((e){
       isLogging = false;
       notifyListeners();
       onFail();
     });
   }

   void resetPass(String email, VoidCallback onSuccess, VoidCallback onFail) async{
     isLogging = true;
     notifyListeners();
     await _auth.sendPasswordResetEmail(email: email).then((s){
       isLogging = false;
       notifyListeners();
       onSuccess();
     }).catchError((e){
       isLogging = false;
       notifyListeners();
       onFail();
     });
   }

   void singUp ( Map<String, dynamic> userData, String pass, VoidCallback onSuccess, VoidCallback onFail ) async{
     
     isLogging = true;
     notifyListeners();


     await _auth.createUserWithEmailAndPassword(email: userData["email"], password: pass).then((s) async{
       isLogging = false;
       notifyListeners();
        this.userData = userData;
       await _db.collection("users").document(s.uid).setData({
         "uid": s.uid,
         "name": userData["name"],
         "email": userData["email"],
         "photo": ""
       });
      onSuccess();
     }).catchError((e){
       isLogging = false;
       notifyListeners();
       onFail();
     });
   }
  Future<Null> _loadCurrentUser() async {
    if(currentUser == null)
      currentUser = await _auth.currentUser();
    if(currentUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser =
        await Firestore.instance.collection("users").document(currentUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

}