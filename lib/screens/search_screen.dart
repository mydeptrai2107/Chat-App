import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  UserModel user;
  SearchScreen(this.user);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').where("name", isEqualTo: _controller.text).get().then((value) => {
      if(value.docs.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("No User Found"))),
        setState((){
          isLoading = false;
        }),
      },

      value.docs.forEach((user) {
        if(user.data()['email'] != widget.user.email){
          searchResult.add(user.data());
        }
      }),
      setState(() {
        isLoading = false;
      })
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
            Container(
              width: 300,
              margin:const EdgeInsets.symmetric( vertical: 10),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search your friend",
                  hintStyle: TextStyle(fontSize: 18),
                  fillColor: Color.fromARGB(255, 228, 224, 224),
                  filled: true
                ),               
              ),
            ),
          
          IconButton(
            onPressed: (){
              onSearch();
            }, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: Column(
        children: [
          if(searchResult.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(searchResult[index]['image']),
                    ),
                    title: Text(searchResult[index]['name']),
                    subtitle: Text(searchResult[index]['email']),
                    trailing: IconButton(
                      onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context){
                            return ChatScreen(
                              widget.user, 
                              searchResult[index]['uid'], 
                              searchResult[index]['name'], 
                              searchResult[index]['image']
                            );
                          } 
                          )
                        );
                      },
                      icon: const Icon(Icons.message),
                    ),
                  );
                }
              )
            )
          else if(isLoading == true)
            const Center(child: CircularProgressIndicator(),)
        ],
      ),
    );
  }
}