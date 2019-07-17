import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<AppState>(
          child: MyHomePage(),
          builder: (_) => AppState(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          "assets/images/logo.png",
          height: 16.0,
        ),
        title: Text(
          "Luma",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        /* Color(0xfff37b1f), */
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.apps),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: MainContent(),
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final appState = Provider.of<AppState>(context);

    Future<void> fetchPost(String search) async {
      //final String url = 'https://143a0284.ngrok.io/server.php';
      final String url =
          'http://m23ee-mag2-demo.datasolution-aspac.site/graphql';
      String payLoad = r'''
                    {"query":"{products(search:\" $search \"){items{sku,name}}}"}
      ''';

      print('>>>' + payLoad + '<<<');
      Map<String, String> requestHeaders = {'Content-type': 'application/json'};
      final response =
          await http.post(url, headers: requestHeaders, body: payLoad);

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        // If that response was not OK, throw an error.
        //throw Exception('Failed to load post');
        print(response.body);
      }
    }

    doSearch(String search) {
      print('Search for ' + search);

      fetchPost(search);
    }

    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xfff46e27),
      alignment: Alignment(0.0, 0.0),
      child: Column(
        children: <Widget>[
          TextField(
            maxLines: 1,
            maxLength: 50,
            textInputAction: TextInputAction.search,
            onSubmitted: (text) => doSearch(text),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.search),
              hintText: "Search products",
              counterText: "",
              border: InputBorder.none,
            ),
          ),
          RaisedButton(
            child: Text("Hit me"),
            onPressed: () => doSearch('shirt'),
          ),
        ],
      ),
    );
  }
}

class FAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          appState.setCounter(appState.getCounter + 1);
        });
  }
}

class AppState with ChangeNotifier {
  AppState();

  int _counter = 0;

  void setCounter(int counter) {
    _counter = counter;
    notifyListeners();
  }

  int get getCounter => _counter;
}
