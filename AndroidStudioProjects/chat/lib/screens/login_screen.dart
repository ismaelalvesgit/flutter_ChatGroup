import 'dart:async';

import 'package:chat/models/user_model.dart';
import 'package:chat/screens/createUser_screen.dart';
import 'package:chat/screens/forgot_screen.dart';
import 'package:chat/screens/paniel_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        );

    return Scaffold(
      key: _scaffoldKey,
      body: ScopedModelDescendant <UserModel>(builder: (context, child, model){
        if(model.isLogging)

          return Center(child: CircularProgressIndicator(),);

        return Stack(
          children: <Widget>[
            _buildBodyBack(),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(vertical: 50.0)),
                    Icon(Icons.check, size: 140.0, color: Colors.white,),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: InputDecoration(
                                  icon:  Icon(Icons.person, color: Colors.white,),
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Email",
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: "Digite seu email"
                              ),
                              style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                              validator: (text){
                                if(text.isEmpty){
                                  return "Email e requirido";
                                }else if (!text.contains("@")){
                                  return "Emalil está invalido";
                                }
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  icon:  Icon(Icons.lock, color: Colors.white,),
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Passoword",
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: "Digite sua senha"
                              ),
                              style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                              validator: (text){
                                if(text.isEmpty ){
                                  return "Senha e requirida !!";
                                }else if (text.length < 6){
                                  return "No minimo 6 caracteres";
                                }
                              },
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 50.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ForgotScreen()));
                        },
                          child: Text("Recupere a sua Senha",
                          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                          )
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(color: Colors.black45, width: 5.0,),
                          ),
                          child: IconButton(
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                UserModel.of(context).singIn(_emailController.text, _passwordController.text, _onSuccess, _onFail);
                              }
                            },
                            icon: Icon(Icons.arrow_forward, color: Colors.white,),
                            tooltip: "Logar",
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 120.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Cadastre agora",
                          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        FlatButton(onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>CreateUserScreen()));
                        },
                            child: Text("Cadastre-se",
                              style: TextStyle(color: Colors.grey, fontSize: 22.0, fontWeight: FontWeight.bold),
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        );
      })
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Login ${_emailController.text} feito com Sucesso !!!",),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 5),
      )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>PainelScreen()));
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao Entrar!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
