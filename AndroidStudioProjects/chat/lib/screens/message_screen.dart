import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class MessageScreen extends StatefulWidget {

  final String room;

  MessageScreen({Key key, this.room}) : super (key: key) ;

  @override
  _MessageScreenState createState() => _MessageScreenState( room: this.room);
}

class _MessageScreenState extends State<MessageScreen> {

  final String room;

  _MessageScreenState({ Key key ,this.room});

  final _msgController = TextEditingController();

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant <MessageModel>(
      builder: (context, child, model){
        if(model.isLogging)
          return Center(child: CircularProgressIndicator());
        return SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Menssagens"),
                centerTitle: true,
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                      child: StreamBuilder(
                          stream: Firestore.instance.collection("chat").document(room).collection("messagem").orderBy("date").snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              default:
                                return ListView.builder(
                                    reverse: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      List m = snapshot.data.documents.reversed.toList();
                                      if(m[index].data["email"] != UserModel.of(context).currentUser.email){
                                        return _widgetMessage1(m[index].data);
                                      }
                                      return _widgetMessage2(m[index].data);
                                    });
                            }
                          })
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: _widgetTextComposer())
                ],
              ),
            ));
      },

    );
  }

  Widget _widgetTextComposer() {

    void _reset() {
      setState(() {
        _msgController.clear();
        _isComposing = false;
      });
    }

    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child:
                  IconButton(icon: Icon(Icons.photo_camera), onPressed: () {}),
            ),
            Expanded(
              child: TextField(
                controller: _msgController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar Messagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: (text) {
                  MessageModel.of(context).sendMessage(_msgController.text, UserModel.of(context).currentUser.email, room);
                  _reset();
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        onPressed: _isComposing ? () {
                          MessageModel.of(context).sendMessage(_msgController.text, UserModel.of(context).currentUser.email, room);
                          _reset();
                        } : null)
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing ? () {
                          MessageModel.of(context).sendMessage(_msgController.text, UserModel.of(context).currentUser.email,  room);
                          _reset();
                        } : null)),
          ],
        ),
      ),
    );
  }

  Widget _widgetMessage1( Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://s3-us-west-2.amazonaws.com/s.cdpn.io/195612/chat_avatar_03.jpg"),
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(10.0)),
                border: Border.all(width: 5.0, color: Colors.greenAccent)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["email"],
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(data["msg"]),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _widgetMessage2(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  border: Border.all(width: 5.0, color: Colors.blueAccent)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    data["email"],
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(data["msg"]),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  UserModel.of(context).userData["photo"]),
            ),
          ),
        ],
      ),
    );
  }
}
