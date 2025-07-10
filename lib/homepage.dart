/*import 'dart:convert';

import'package:flutter/material.dart';
import'package:http/http.dart'as http;
import 'package:untitled/Models/post_models.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  List<PostModels> postList=[];
  Future<List<PostModels>> getPostApi() async{
    final response=await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var data= jsonDecode(response.body.toString());
    if(response.statusCode==200){
      postList.clear();
      for (Map<String, dynamic> i in data) {
        postList.add(PostModels.fromJson(i));  // You have to change this from JSOn to fromMap thanks
      }
      return postList;
    }
    else{
      return postList;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(
          child: Text("Api Integeration",
            style:TextStyle(fontSize: 21,fontWeight: FontWeight.bold,color: Colors.black,)
            ,),
        ),backgroundColor: Colors.cyanAccent,
      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(
          future: getPostApi(),
              builder:(context,snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading');
                }
                else {
                  return ListView.builder(itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(postList[index].title.toString())
                        ],
                      ),
                    );
                  });
                }
              },
            ),)
        ],
      )
    );
  }
}
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Models/post_models.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<PostModels> postList = [];
  bool isLoading = true;
  bool hasError = false;
  final ScrollController _scrollController = ScrollController(); // Add this

  Future<List<PostModels>> getPostApi() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        postList.clear();
        for (Map<String, dynamic> i in data) {
          postList.add(PostModels.fromJson(i));
        }
        setState(() {
          isLoading = false;
          hasError = false;
        });
        return postList;
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
        return postList;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      return postList;
    }
  }

  @override
  void initState() {
    super.initState();
    getPostApi();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "API Integration",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
                hasError = false;
              });
              getPostApi();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading Posts...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (hasError)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load posts',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          hasError = false;
                        });
                        getPostApi();
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Scrollbar( // Added Scrollbar for better UX
                controller: _scrollController, // Connect controller
                child: ListView.separated(
                  controller: _scrollController, // Connect controller
                  padding: const EdgeInsets.all(16),
                  itemCount: postList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    postList[index].title.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              postList[index].body.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_scrollController.hasClients) { // Check if controller is attached
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}