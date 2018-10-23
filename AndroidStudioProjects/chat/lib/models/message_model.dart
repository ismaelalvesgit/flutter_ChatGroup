import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class MessageModel extends Model{

  static MessageModel of(BuildContext context)=>
      ScopedModel.of<MessageModel>(context);

}