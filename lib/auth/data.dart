import 'package:flutter/material.dart';

class DataManager extends ChangeNotifier {
  Map<String, dynamic> _user = {};
  Map<String, dynamic> _chat = {};

  set user (userObject)
  {
    _user = userObject;
    notifyListeners();
  }
  
  set chat (chatObject)
  {
    _chat = chatObject;
    notifyListeners();
  }

  get user => _user;
  get chat => _chat;
}