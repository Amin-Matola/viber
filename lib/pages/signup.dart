import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sham/auth/authenticator.dart';

class Signup extends StatefulWidget {

  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController passwd = TextEditingController();

  bool isLoading = false;
  
  Map<String, dynamic> credentials = {
    'username': null,
    'firstName': null,
    'lastName': null,
    'phone': null,
    'password': null
  };

  Widget _buildField({
    String label = "", 
    TextEditingController? controller, 
    TextInputType? type,
    IconData? icon
  })
  {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.deepPurple),
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor,),
        labelText: label,
      ),
    );
  }

  void signup() async
  {
    credentials['username'] = username.text;
    credentials['firstName'] = firstName.text;
    credentials['lastName'] = lastName.text;
    credentials['phone'] = phone.text;
    credentials['password'] = passwd.text;

    final auth = Authenticator();

    setState(() {
      isLoading = true;
    });

    try {
      await auth.signup(json.encode(credentials));

      if (auth.isSuccess)
      {
        isLoading = false;
        Navigator.pushNamed(context, '/');
      }
    } catch(e)
    {
      Fluttertoast.showToast(
        msg: "Failed: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG, // Duration: Short or Long
        gravity: ToastGravity.CENTER,    // Position: TOP, CENTER, or BOTTOM
        backgroundColor: Colors.green,  // Background color
        textColor: Colors.white,        // Text color
        fontSize: 16.0,                 // Font size
      );
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(Icons.keyboard_arrow_left, color: Theme.of(context).primaryColor,)
        ),
       title: Text("Back", style: TextStyle(color: Theme.of(context).primaryColor),),
      ),
      body:  Center(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 24, right: 24),
          child: SingleChildScrollView(
            child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildField(
                label: "User Name (e.g amin)",
                controller: username,
                type: TextInputType.text,
                icon: Icons.person
              ),
              SizedBox(height: 16),
              _buildField(
                label: "First Name",
                controller: firstName,
                type: TextInputType.text,
                icon: Icons.abc
              ),
              SizedBox(height: 16),
              _buildField(
                label: "Last Name",
                controller: lastName,
                type: TextInputType.text,
                icon: Icons.abc
              ),
              SizedBox(height: 16),
              _buildField(
                label: "Phone Number",
                controller: phone,
                type: TextInputType.phone,
                icon: Icons.phone
              ),
              SizedBox(height: 16,),
              TextField(
                obscureText: true,
                controller: passwd,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.deepPurple),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),
                  labelText: "Password",
                ),
              ),
              SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: signup, 
                  label: Text("Signup"),
                  icon: isLoading? SizedBox(
                    width: 24,
                    height: 24,
                    child:CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 1,
                    ) 
                  ) : Icon(Icons.app_registration_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    iconColor: Colors.white
                  ),
                )
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  "Already have account?", 
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                    fontSize: 16,
                ),),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  }, 
                  child: Text(
                    "Login",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                )
              ])
            ]),
          )
        ),
      )
    );
  }
}