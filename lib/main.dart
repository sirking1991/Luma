import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:Luma/appstate.dart';
import 'package:Luma/cartpage.dart';
import 'package:Luma/pageanimations.dart';
import 'package:Luma/productitem.dart';
import 'package:Luma/producttile.dart';
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
          builder: (_) => AppState(null),
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
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
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
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                      context, SlideRightRoute(page: CartPage(appState.cart)));
                },
              ),
              cartQtyBadge(context),
            ],
          ),
        ],
      ),
      body: Container(
        child: MainContent(),
        padding: EdgeInsets.all(10),
        color: Color(0xfff46e27),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}

Widget cartQtyBadge(BuildContext context) {
  final appState = Provider.of<AppState>(context);

  if (0 == appState.cart.getCartItemCount().round()) return Container();

  return Positioned(
    top: 0, right: 15,
    child: Container(
      child: Text(
        appState.cart.getCartItemCount().round().toString(),
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ),
  );
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    void promptNoProductFound() {
      final snackBar = SnackBar(
        content: Text('No product found'),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      print("No product found!");
    }

    Future<void> fetchPost(String search) async {
      final String url =
          'https://2-3-2-3g456uy-7t6qpzagrbri4.us-4.magentosite.cloud/graphql';
      String payLoad = '''
                      {
                        "query": 
                        "{
                          products(search:\\"[SEARCH_QUERY]\\") {
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

      payLoad = payLoad
          .replaceAll('\n', '')
          .replaceAll(' ', '')
          .replaceAll('[SEARCH_QUERY]', search);
      print('>>>' + payLoad + '<<<');
      Map<String, String> requestHeaders = {'Content-type': 'application/json'};
      final response =
          await http.post(url, headers: requestHeaders, body: payLoad);

      if (response.statusCode == 200) {
        print(response.body);
        var productList = jsonDecode(response.body);

        appState.clearProductList();

        if (productList['data']['products'] == null) {
          promptNoProductFound();
        } else {
          if (productList['data']['products']['items'].length == 0) {
            promptNoProductFound();
          } else {
            for (var i = 0;
                i < productList['data']['products']['items'].length;
                i++) {
              var productItem = productList['data']['products']['items'][i];
              appState.addProductList(new ProductItem(
                  productItem['sku'],
                  productItem['name'],
                  productItem['image']['url'],
                  productItem['price']['regularPrice']['amount']['value']
                      .toDouble()));
            }
            appState.notifyTheListeners();
          }
        }
      } else {
        // If that response was not OK, throw an error.
        //throw Exception('Failed to load post');
        print(response.body);
      }
    }

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: TextField(
            maxLines: 1,
            maxLength: 100,
            textInputAction: TextInputAction.search,
            onSubmitted: (text) => fetchPost(text),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.search),
              hintText: "Search products",
              counterText: "",
              border: InputBorder.none,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              ProductItem productItem = appState.getProductDisplayList[index];
              return productTile(context, productItem);
            },
            itemCount: appState.getProductCount,
          ),
        ),
      ],
    );
  }
}
