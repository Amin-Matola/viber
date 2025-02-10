import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sham/auth/authenticator.dart';
import 'package:sham/auth/data.dart';
import 'package:sham/components/message.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  ScrollController _scrollController = ScrollController();
  final auth = Authenticator();
  List<Map<String, dynamic>> messages = [];
  bool isInitialized = false;
  bool isLoading = false;

  var chat, user;

  bool isSender(message)
  {
    return message['sender'] == user['id'];
  }

  dynamic sendMessage(message) async
  {
    
    final item = {
      'message': message, 
      'sender': user['id'],
      'receiver': chat['id']
    };

    await auth.sendMessage(json.encode(item));

    init();
  }

  void setUserStates()
  {

    if (user == null || chat == null) {
      setState(() {
        user = Provider.of<DataManager>(context).user;
        chat = Provider.of<DataManager>(context).chat;
      });
    }
  }

     // Scroll to the bottom of the list
  void _scrollToBottom() {
    // Check if the controller is attached to a scrollable widget
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  init() async
  {

    await auth.getMessages(user['id'], chat['id']);

    setState(() {
      messages = List<Map<String, dynamic>>.from(auth.data);
    });

    if (!isInitialized) {
      isInitialized = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    
  }

  @override
  Widget build(BuildContext context) {

    setUserStates();

    if (!isInitialized) {
      init();
    }
    
    if ( user == null) {
      Navigator.pushNamed(context, "/");
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 24,
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,)
        ),
        title:Text("${chat['username']}"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.blueGrey,
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(360)),
            child: (chat['profile']?.length ?? 0) > 0? 
              Image.network(
                chat['profile'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ) :  
              Image.asset(
                'assets/images/male.png',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Fluttertoast.showToast(
                msg: "${user['firstName']}, calls are not enabled yet.",
                toastLength: Toast.LENGTH_LONG, // Duration: Short or Long
                gravity: ToastGravity.CENTER,    // Position: TOP, CENTER, or BOTTOM
                backgroundColor: Colors.lightGreen,  // Background color
                textColor: Colors.white,        // Text color
                fontSize: 16.0,                 // Font size
              );
            }, 
            icon: Transform.rotate(
              angle: 270 * 3.14159 / 180,
              child: Icon(
                size: 26,
                Icons.call,
              )
            )),
          SizedBox(width: 4),
          PopupMenuButton(itemBuilder: (context) {
            return [
            
              PopupMenuItem<int>(
                value: 1, 
                child: 
                Row(
                  children: [
                    Icon(Icons.person, color: Theme.of(context).primaryColor,),
                    SizedBox(width: 30),
                    Text("Profile", style: TextStyle(color: Theme.of(context).primaryColor),)
                  ]
                )
              ),
              PopupMenuItem<int>(
                value: 2, 
                child: 
                Row(
                  children: [
                    Icon(Icons.settings, color: Theme.of(context).primaryColor,),
                    SizedBox(width: 30),
                    Text("Settings", style: TextStyle(color: Theme.of(context).primaryColor),)
                  ]
                )
              ),
            ];
          })
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(  // Use Expanded to make Column take available space
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (messages.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height/2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("No messages yet")]
                      )
                    ),
                  for (var i = 0; i < messages.length; i++)
                    Row(
                      mainAxisAlignment: isSender(messages[i])? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
                              decoration: BoxDecoration(
                                color: isSender(messages[i])? Theme.of(context).primaryColor : Color(0xFFDEDEDE),
                                borderRadius: BorderRadius.circular(16)
                              ),
                              child: Text(
                                "${messages[i]['message']}", 
                                style: TextStyle(color: isSender(messages[i])? Colors.white : Colors.black),
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 14),
                          child:Text(
                            "${DateFormat('hh:mm a').format(DateTime.parse(messages[i]['created_at']))}", 
                          style: TextStyle(fontSize: 8),)
                        )
                      ],
                  )]),
                ],
              ),
            ),
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 24),
                  child: Message(onSend: sendMessage))
              )
            ],
          )
        ],
      ),
    );
  }
}