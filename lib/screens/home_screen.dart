import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/search_screen.dart';
import 'package:chatapp/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  UserModel userModel;
  HomeScreen(this.userModel, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: (){
            FirebaseService().signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()) 
          );
          }, 
          icon: const Icon(Icons.logout))
        ],
      ),


      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.userModel.uid).collection('messages').snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length < 1){
              return const Center(
                child: Text(
                  "No Chats Available!"
                ),
              );
            } 
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var friendId = snapshot.data.docs[index].id;
                var lastMsg = snapshot.data.docs[index]['last_msg'];
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                  builder: (context, AsyncSnapshot asyncSnap){
                    if(asyncSnap.hasData){
                      var friend = asyncSnap.data;
                      return ListTile(
                        leading: CircleAvatar(
                          child: Image.network(friend['image']),
                        ),
                        title: Text(friend['name']),
                        subtitle: Container(
                          child: Text(
                            lastMsg,
                            style: const TextStyle(
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context){
                            return ChatScreen(
                              widget.userModel, 
                              friend['uid'], 
                              friend['name'], 
                              friend['image']
                            );
                          } 
                          )
                        );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                );
                
              }
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context){
              return SearchScreen(widget.userModel);
            })
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}