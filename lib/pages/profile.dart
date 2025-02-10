import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sham/auth/authenticator.dart';
import 'package:sham/auth/data.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  File? _image;
  final ImagePicker picker = ImagePicker();
  var user;
  bool isLoading = false;

  Future<void> selectImage() async
  {
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);

    final auth = Authenticator();

    if (selectedImage != null)
    {

      setState(() {
        isLoading = true;
      });

      await auth.uploadPicture(selectedImage, user['id']);

      if (auth.isSuccess) {
        final _user = auth.data;

        print(_user);
        

        if( _user.containsKey("profile"))
        {
          context.read<DataManager>().user = _user;
          //   setState(() {
          //   user = _user;
          // });
        }
        
        Fluttertoast.showToast(
          msg: "Profile picture uploaded!",
          toastLength: Toast.LENGTH_LONG, // Duration: Short or Long
          gravity: ToastGravity.CENTER,    // Position: TOP, CENTER, or BOTTOM
          backgroundColor: Colors.green,  // Background color
          textColor: Colors.white,        // Text color
          fontSize: 16.0,                 // Font size
        );
      }
      else {
        
        Fluttertoast.showToast(
          msg: "Could not upload profile!",
          toastLength: Toast.LENGTH_SHORT, // Duration: Short or Long
          gravity: ToastGravity.BOTTOM,    // Position: TOP, CENTER, or BOTTOM
          backgroundColor: Colors.red,  // Background color
          textColor: Colors.white,        // Text color
          fontSize: 16.0,                 // Font size
        );
      }

      setState(() {
        isLoading = false;
      });
    }
    else {
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<DataManager>(context).user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(Icons.keyboard_arrow_left, color: Theme.of(context).primaryColor,)
        ),
       title: Text("Back", style: TextStyle(color: Theme.of(context).primaryColor),),
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(360)),
                    border: Border.all(
                      color: Colors.white,
                      width: 2
                    )
                  ),
                  width: 164,
                  height: 164,
                  child: 
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(360)),
                      child: InkWell(
                        onTap: selectImage,
                        child: (user['profile']?.length ?? 0) > 0 ? 
                        Image.network(
                          user['profile'],
                          width: 164,
                          height: 164,
                          fit: BoxFit.cover,
                        ) :  Image.asset(
                          'assets/images/male.png',
                          width: 164,
                          height: 164,
                          fit: BoxFit.cover,
                        )
                      )
                    )
                  ),
                  SizedBox(height: 40),
                  Text("${user['firstName']} ${user['lastName']}", style: TextStyle(
                    fontSize: 22, 
                    color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 40),

                  if (isLoading)
                    Container(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 4,
                    ))
                  // IconButton(
                  //   onPressed: () {}, 
                  //   icon: Icon(Icons.photo_camera),
                  //   iconSize: 64,
                  // )
              ]
            )
          ),
        )
      )
    );
  }
}