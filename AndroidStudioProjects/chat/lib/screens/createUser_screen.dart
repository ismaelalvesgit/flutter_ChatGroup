import 'package:chat/models/user_model.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
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
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLogging)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Stack(
            children: <Widget>[
              _buildBodyBack(),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.symmetric(vertical: 50.0)),
                      Icon(
                        Icons.check,
                        size: 140.0,
                        color: Colors.white,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.perm_contact_calendar,
                                      color: Colors.white,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "Name",
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: "Digite seu Nome"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "O Campo nome e requerido";
                                  }
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "Email",
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: "Digite seu email"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "Email esta invalido";
                                  }
                                },
                              ),
                              TextFormField(
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "Passoword",
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: "Digite sua senha"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                                validator: (text) {
                                  if (text.isEmpty || text.length < 6) {
                                    return "Senha esta incorreta !!";
                                  }
                                },
                              ),
                            ],
                          )),
                      SizedBox(height: 50.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(onPressed: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                              child: Text("Fazer Login",
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
                                onPressed: (){},
                                icon: Icon(Icons.arrow_forward, color: Colors.white,),
                                tooltip: "Cadastrar",
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }

  void _onSuccess() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
