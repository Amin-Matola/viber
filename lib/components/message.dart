import 'package:flutter/material.dart';

class Message extends StatelessWidget {

  TextEditingController message = new TextEditingController();
  late final Function(dynamic)? onSend;

  Message({this.onSend, super.key});

  void successCallback()
  {
    this.onSend?.call(message.text);
    message.value = TextEditingValue.empty;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: message,
      minLines: 1,
      maxLines: 4,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(100))
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor,),
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        suffixIcon: IconButton(
          onPressed: successCallback,
          icon: Icon(
            Icons.send, 
            color: Theme.of(context).primaryColor
          ),
        ),
        // labelText: "Message",
        hintText: "Write message...",
        // floatingLabelBehavior: FloatingLabelBehavior.never
      ),
    );
  }
}