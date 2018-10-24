import 'dart:io';

import 'package:chat/models/user_model.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PainelScreen extends StatefulWidget {
  @override
  _PainelScreenState createState() => _PainelScreenState();
}

class _PainelScreenState extends State<PainelScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant <UserModel>(
      builder: (context, child, model){
        if(model.isLogging)
          return Center(child: CircularProgressIndicator(),);

        return Scaffold(
          appBar: AppBar(
            title: Text("Contatos"),
            centerTitle: true,
            actions: <Widget>[
              InkWell(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.exit_to_app, color: Colors.white,),
                ),
                onTap: (){
                  UserModel.of(context).singOut(_onSuccess, _onFail);
                },
              ),
            ],
          ),
          body: StreamBuilder <QuerySnapshot>(
              stream: Firestore.instance.collection("users").snapshots(),
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                return Center(
                child: CircularProgressIndicator(),
                );
                default:
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    List d = snapshot.data.documents.toList();
                    return InkWell(
                      onTap: (){},
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: d[index].data["photo"] == null ? AssetImage("imagens/person.png") : NetworkImage(d[index].data["photo"]),
                                        fit: BoxFit.fill
                                    )
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(d[index].data["email"]),
                                    Text(d[index].data["name"])
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );

                  },
                );
                }
              }
          )
        );
      },
    );
  }

  Widget _widgetListUsers( Map<String, dynamic> users){
    print(users["email"]);
    return InkWell(
      onTap: (){},
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(users["photo"]),
                        fit: BoxFit.fill
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(users["email"]),
                    Text(users["name"])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSuccess(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao Sair!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}

