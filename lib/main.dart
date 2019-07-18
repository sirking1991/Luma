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
            icon: Icon(Icons.shopping_cart),
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
    final appState = Provider.of<AppState>(context);

    Future<void> fetchPost(String search) async {
      final String url =
          'https://2-3-2-3g456uy-7t6qpzagrbri4.us-4.magentosite.cloud/graphql';
      String payLoad = '''
                      {
                        "query": 
                        "{
                          products(search:\\"$search\\") {
                            items {
                              sku,
                              name,
                              image{url},
                              stock_status,
                              price {
                                regularPrice {amount {currency,value}}
                              }
                            }
                          }
                        }"
                      } 
                      ''';

      payLoad = payLoad.replaceAll('\n', '').replaceAll(' ', '');
      print('>>>' + payLoad + '<<<');
      Map<String, String> requestHeaders = {'Content-type': 'application/json'};
      final response =
          await http.post(url, headers: requestHeaders, body: payLoad);

      if (response.statusCode == 200) {
        //print(response.body);
        var productList = jsonDecode(response.body);

        appState
            .setProductDisplayList(productList['data']['products']['items']);

        print(productList['data']['products']['items'].length);
      } else {
        // If that response was not OK, throw an error.
        //throw Exception('Failed to load post');
        print(response.body);
      }
    }

    doSearch(String search) {
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
          
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _productTile(context, 'Kratos Gym Pant',
                  'https://2-3-2-3g456uy-7t6qpzagrbri4.us-4.magentosite.cloud/media/catalog/product/cache/2af9ad1f71bf4691ae09750f76d6350d/m/p/mp01-gray_main_1.jpg'),
              _productTile(context, 'Caesar Warm-Up Pant',
                  'https://2-3-2-3g456uy-7t6qpzagrbri4.us-4.magentosite.cloud/media/catalog/product/cache/2af9ad1f71bf4691ae09750f76d6350d/m/p/mp11-brown_main_1.jpg'),
              _productTile(context, 'Aether Gym Pant',
                  'https://2-3-2-3g456uy-7t6qpzagrbri4.us-4.magentosite.cloud/media/catalog/product/cache/2af9ad1f71bf4691ae09750f76d6350d/m/p/mp02-gray_main_2.jpg'),
              _productTile(context, 'Livingston All-Purpose Tight',
                  'https://2-3-2-3g456uy-7t6qpzagrbri4.us-4.magentosite.cloud/media/catalog/product/cache/2af9ad1f71bf4691ae09750f76d6350d/m/p/mp04-gray_main_1.jpg'),
              _productTile(context, 'Thorpe Track Pant',
                  'https://2-3-2-3g456uy-7t6qpzagrbri4.us-4.magentosite.cloud/media/catalog/product/cache/2af9ad1f71bf4691ae09750f76d6350d/m/p/mp05-blue_main_1.jpg'),
            ],
          )
        ],
      ),
    );
  }
}

Widget _productTile(BuildContext context, String name, String imageURL) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(top: 10.0),
    height: 460,
    width: 400,
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Column(
        children: <Widget>[
          Image(
            height: 350,
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            image: NetworkImage(imageURL),
          ),
          Spacer(),
          Text(
            name,
            style: TextStyle(fontSize: 20.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: new Icon(Icons.star_border, color: Colors.red, size: 35,),
                onPressed: () {
                  print('favorite tapped!');
                },
              ),
              IconButton(
                icon: new Icon(Icons.add_shopping_cart, color: Colors.red, size: 35,),
                onPressed: () {
                  print('added to cart');
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// class FAB extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     return FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           appState.setCounter(appState.getCounter + 1);
//         });
//   }
// }

class AppState with ChangeNotifier {
  AppState();

  List _productDisplayList = [];

  void setProductDisplayList(List list) {
    _productDisplayList = list;
    notifyListeners();
  }

  List get getProductDisplayList => _productDisplayList;
}
