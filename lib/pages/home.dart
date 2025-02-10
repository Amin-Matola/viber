import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sham/auth/authenticator.dart';
import 'package:sham/auth/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController phone = TextEditingController();
  TextEditingController passwd = TextEditingController();

  bool isLoading = false;
  bool incorrent = false;

  Map<String, dynamic> credentials = {
    'phone': null,
    'password': null
  };

  void login() async
  {
    credentials['phone'] = phone.text;
    credentials['password'] = passwd.text;

    setState(() {
      isLoading = true;
    });

    final auth = Authenticator();

    try {
      await auth.authenticate(credentials);
    
      final resp = Map<String, dynamic>.from(auth.data);
      final user = Map<String, dynamic>.from(auth.data)['user'];

      if (auth.isSuccess && resp.containsKey("authentic") && resp['authentic'] == true)
      {

        Provider.of<DataManager>(context, listen: false).user = user;
        Navigator.pushNamed(context, '/home');
        setState(() {
          incorrent = true;
          isLoading = false;
        });
      }
      else {
        setState(() {
          incorrent = true;
          isLoading = false;
        });
      }
    }
    catch(e)
    {
      Fluttertoast.showToast(
        msg: "Login error: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG, // Duration: Short or Long
        gravity: ToastGravity.CENTER,    // Position: TOP, CENTER, or BOTTOM
        backgroundColor: Colors.green,  // Background color
        textColor: Colors.white,        // Text color
        fontSize: 16.0,                 // Font size
      );
    }
    finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 24, right: 24),
          child: SingleChildScrollView(
            child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/chat.png',
                width: 150,
                height: 150
              ),
              SizedBox(width: 50),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
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
                  prefixIcon: Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                  labelText: "Phone Number",
                ),
              ),
              SizedBox(height: 40,),
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
              SizedBox(height: 10),
              if (incorrent)
              Row(children: [
                Text("Incorrect login details", style: TextStyle(color: Colors.redAccent),)
              ]),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: login, 
                  label: Text("Login"),
                  icon: isLoading? SizedBox(
                    width: 24,
                    height: 24,
                    child:CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 1,
                    ) 
                  ): Icon(Icons.check),
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
                  "Don't have account?", 
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                    fontSize: 16,
                ),),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  }, 
                  child: Text("Signup",
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