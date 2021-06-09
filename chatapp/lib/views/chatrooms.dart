import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth.dart';
//import 'package:chatapp/views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    snapshot.data.docs[index]
                        .data()['chatRoomID']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    snapshot.data.docs[index].data()["chatRoomID"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomStream = val;
        print(
            "we got the data + ${chatRoomStream.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('GoVID app'),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomList(),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomID;
  ChatRoomTile(this.userName, this.chatRoomID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(chatRoomID)));
      },
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.black38,
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(width: 12),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
