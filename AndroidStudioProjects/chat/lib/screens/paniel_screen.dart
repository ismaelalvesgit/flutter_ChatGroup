import 'package:chat/models/user_model.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
          body: Container(),
        );
      },
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

