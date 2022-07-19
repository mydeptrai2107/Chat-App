import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/widgets/message_textfield.dart';
import 'package:chatapp/widgets/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen(this.currentUser, this.friendId, this.friendName, this.friendImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(friendImage, height: 35,),
            ),
            const SizedBox(width: 5,),
            Text(friendName, style: const TextStyle(fontSize: 20),)
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
                )
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('messages').doc(friendId).collection('chats').orderBy('date', descending: true).snapshots(),
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data.docs.length < 1){
                      return const Center(
                        child: Text('Say hi'),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        bool isMe = snapshot.data.docs[index]['senderId'] == currentUser.uid;
                        return SingleMessage(snapshot.data.docs[index]['message'], isMe);
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          MessageTextField(currentUser.uid, friendId),
        ],
      ),
    );
  }
}