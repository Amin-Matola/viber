import 'package:flutter/material.dart';

class Topnav extends StatelessWidget {
  const Topnav({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(360)),
          child: Image.asset(
            'assets/images/chat2.png',
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          )
        )
      ),
      title: Text("Amin"),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shadowColor: Colors.blueGrey,
      actions: [
        PopupMenuButton(itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 1, 
              child: 
              Row(
                children: [
                  Icon(Icons.settings, color: Theme.of(context).primaryColor,),
                  SizedBox(width: 10),
                  Text("Settings", style: TextStyle(color: Theme.of(context).primaryColor),)
                ]
              )
            )
          ];
        })
      ],
    );
  }
}