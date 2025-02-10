import 'dart:convert';

import 'package:http/http.dart' as client;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class Authenticator {

  var _response, _data;
  bool isSuccess = false;

  final endpoint = "https://vibes.pythonanywhere.com/messages";

  dynamic getEndpoint(String endpt)
  {
    return Uri.parse("$endpoint/$endpt");
  }

  Future <void> authenticate(credentials) async
  {
    _response = await client.post(getEndpoint("authenticate"), headers: {}, body: credentials);

    if (_response.statusCode == 200)
    {
      isSuccess = true;
      _data = jsonDecode(_response.body);
    }
  }
  
  Future <void> signup(credentials) async
  {
    _response = await client.post(getEndpoint("signup"), headers: {}, body: credentials);

    if (_response.statusCode == 200)
    {
      isSuccess = true;
      _data = jsonDecode(_response.body);
    }
  }
  
  Future <void> sendMessage(message) async
  {
    _response = await client.post(getEndpoint("send"), headers: {}, body: message);

    if (_response.statusCode == 200)
    {
      isSuccess = true;
      _data = jsonDecode(_response.body);
    }
  }

  Future <void> getUsers() async
  {
    _response = await client.get(getEndpoint("users"));

    if (_response.statusCode == 200)
    {
      isSuccess = true;
      _data = jsonDecode(_response.body);
    }
  }
  
  Future <void> getMessengers(user) async
  {
    _response = await client.get(getEndpoint("users?user=$user"));

    if (_response.statusCode == 200)
    {
      isSuccess = true;
      _data = jsonDecode(_response.body);
    }
  }
  
  Future <void> getMessages(user, chat) async
  {
    _response = await client.get(getEndpoint("all?user=$user&receiver=$chat"));

    if (_response.statusCode == 200)
    {
      isSuccess = true;
      _data = jsonDecode(_response.body);
    }
  }

  dynamic get response {
    return _response;
  }

  dynamic get data {
    return _data;
  }

  Future <void> uploadPicture(picture, userId) async
  {
    final req   = client.MultipartRequest("POST", getEndpoint("profile"));

    req.fields['user'] = "$userId";

    final mime  = lookupMimeType(picture!.path) ?? "image/jpeg";
    final image = await client.MultipartFile.fromPath(
      "profile", picture.path, contentType: MediaType.parse(mime)
    );

    req.files.add(image);

    _response = await req.send();

    if (_response.statusCode == 200)
    {
      isSuccess = true;

      final data = await _response.stream.bytesToString();
      
      _data = jsonDecode(data);
    }
    else {
      print('Status code ${_response.statusCode}');
    }
  }
}