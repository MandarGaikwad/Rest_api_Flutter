import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post> post;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter REST API Example'),
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            children: [
              _isDataLoaded
                  ? Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Data Fetched Successfully",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: FutureBuilder<Post>(
                              future: post,
                              builder: (context, abc) {
                                if (abc.hasData) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      "Title : " +
                                          "\n${abc.data.title}\n\n" +
                                          "id : " +
                                          "${abc.data.id}\n\n" +
                                          "User ID : " +
                                          "${abc.data.userId}\n\n" +
                                          "Body : " +
                                          "\n${abc.data.body}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                } else if (abc.hasError) {
                                  return Text("${abc.error}");
                                }
                                // By default, it show a loading spinner.
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Error Fetching Data",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.red,
                          )),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child:
                                Text("Please Check your Internet Connection"),
                          ),
                        ),
                      ],
                    )
            ],
          )),
        ),
      ),
    );
  }

  Future<Post> fetchPost() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // If the call to the server was successful (returns OK), parse the JSON.
      var data = Post.fromJson(json.decode(response.body));
      setState(() {
        _isDataLoaded = true;
      });
      return data;
    } else {
      // If that call was not successful (response was unexpected), it throw an error.
      throw Exception('Failed to load post');
    }
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
