import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  bool isLogging = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

   void singIn(String email, String pass, VoidCallback onSuccess, VoidCallback onFail) async{

     isLogging = true;
     notifyListeners();
     await _auth.signInWithEmailAndPassword(email: email, password: pass).then((user){

       isLogging = false;
       notifyListeners();
       currentUser = user;
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


}