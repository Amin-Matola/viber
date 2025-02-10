
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sham/auth/authenticator.dart';
import 'package:sham/auth/data.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  List<Map<String, dynamic>> users = [];
  var user;
  bool isLoading = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  init() async
  {
    final auth  = Authenticator();
    isLoading = true;
    await auth.getUsers();

    setState((){
      users = List<Map<String, dynamic>>.from(auth.data).where((chat) => chat['id'] != user['id']).toList();
      isLoading = false;
    });
  }

  setUser()
  {
    user        = Provider.of<DataManager>(context).user;

    if ( user == null) {
      Navigator.pushNamed(context, "/");
    }
  }

  void showDrawer()
  {
    showModalBottomSheet(
      context: context, 
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
          return Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: users.isNotEmpty ? 
            getUserList(false) :

            Center(
              child: isLoading?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 4,
                  )
                ],
              ) :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 24),
                  Text(
                  "No users available yet.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18
                  ),
                )
              ])
            ) 
          );
    });
  }

  Widget getUserList([leading = true])
  {
    return leading? ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Padding(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(360)),
                child: (users[index]['profile']?.length ?? 0) > 0? 
                  Image.network(
                    users[index]['profile'],
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ) :  
                  Image.asset(
                    'assets/images/male.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ),
              )
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("${users[index]['username'] ?? 'Vibe'}"),
            subtitle: Text("0${users[index]['phone']}"),
            titleTextStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16
            ),
            iconColor: Theme.of(context).primaryColor,
            onTap: (){
              context.read<DataManager>().chat = users[index];
              Navigator.pushNamed(context, '/chat');
            },
          );
        }
      ): ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            trailing: Padding(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(360)),
                child: (users[index]['profile']?.length ?? 0) > 0? 
                  Image.network(
                    users[index]['profile'],
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ) :  
                  Image.asset(
                    'assets/images/male.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ),
              )
            ),
            title: Text("${users[index]['username']}"),
            subtitle: Text("0${users[index]['phone']}"),
            titleTextStyle: TextStyle(color: Theme.of(context).primaryColor),
            iconColor: Theme.of(context).primaryColor,
            onTap: (){
              context.read<DataManager>().chat = users[index];
              Navigator.pushNamed(context, '/chat');
            },
          );
        }
      );
  }

  @override
  Widget build(BuildContext context) {

    final context0 = context;
    setUser();

    return Scaffold(
      appBar: AppBar(
        leading: Row(children: [
          SizedBox(width: 12,),
          Padding(
            padding: EdgeInsets.all(0),
            child: InkWell(
              onTap: () { Navigator.pushNamed(context, "/profile"); },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(360)),
                child: (user['profile']?.length ?? 0) > 0? 
                  Image.network(
                    user['profile'],
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ) :  
                  Image.asset(
                    'assets/images/male.png',
                    width: 32,
                    height: 32,
                    // fit: BoxFit.cover,
                  ),
              ),
            )
        )]),
        title: Text("${user['username']}"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(
                size: 26,
                Icons.notification_add,
              )
            ),
          SizedBox(width: 4),
          PopupMenuButton(itemBuilder: (context) {
            return [
               PopupMenuItem<int>(
                value: 2, 
                child: 
                Row(
                  children: [
                    Icon(Icons.person, color: Theme.of(context).primaryColor,),
                    SizedBox(width: 30),
                    Text("Profile", style: TextStyle(color: Theme.of(context).primaryColor),)
                  ]
                ),
                onTap: () => Navigator.pushNamed(context, "/profile"),
              ),
              PopupMenuItem<int>(
                value: 1, 
                child: 
                Row(
                  children: [
                    Icon(Icons.settings, color: Theme.of(context).primaryColor,),
                    SizedBox(width: 30),
                    Text("Settings", style: TextStyle(color: Theme.of(context).primaryColor),)
                  ]
                )
              ),
              PopupMenuItem<int>(
                value: 1, 
                child: 
                Row(
                  children: [
                    Icon(Icons.logout, color: Theme.of(context).primaryColor,),
                    SizedBox(width: 30),
                    Text("Logout", style: TextStyle(color: Theme.of(context).primaryColor),)
                  ]
                ),
                onTap: () {
                  Navigator.of(context0).pushNamed("/");
                  context.read<DataManager>().user = {};
                },
              )
            ];
          })
        ],
      ),
      body: users.isNotEmpty? 
      getUserList() :
      Center(
        child: isLoading? 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 4,
            )
          ],
        ):
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              size: 64,
              color: Colors.black //Theme.of(context).primaryColor,
            ),
            SizedBox(height: 24),
            Text(
            "No chats available yet.",
            style: TextStyle(
              color: Colors.black,//Theme.of(context).primaryColor,
              fontSize: 18
            ),
          )
        ])
      ) 
      ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () { showDrawer(); },
        child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
      ),
    );
  }
}