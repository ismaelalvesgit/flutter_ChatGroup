import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return ScopedModel<MessageModel>(
          model: MessageModel(),
          child: MaterialApp(
            title: "ChatOnline",
            home: LoginScreen(),
            debugShowCheckedModeBanner: false,
          ),
        );
      }),
    );
  }
}
