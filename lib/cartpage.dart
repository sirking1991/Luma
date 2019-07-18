import 'package:Luma/appstate.dart';
import 'package:Luma/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  Cart cart;

  CartPage(this.cart);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<AppState>(
          child: MyCartPage(),
          builder: (_) => AppState(cart),
        ));
  }
}

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  
  void _confirmCartClear() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          
          return AlertDialog(
            title: Text("Clear shopping cart"),
            content: Text(
                "This will permanently remove items from your shopping cart. \n Do you wish to continue?"),
            actions: <Widget>[
              RaisedButton(
                child:
                    Text("Cancel", style: TextStyle(color: Colors.lightGreen)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              RaisedButton(
                child: Text("Proceed", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  final appState = Provider.of<AppState>(context);
                  appState.cart.clearCart();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping cart"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: (){
              print("Clear cart content");
              _confirmCartClear();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Color(0xfff46e27),
        alignment: Alignment(0.0, 0.0),
        child: Column(
          children: <Widget>[
            Text(
              "Total \$" + appState.cart.getCartTotal().toString(),
              style: TextStyle(fontSize: 40, color: Colors.white),
            )
          ],
        ),
      ),
    );
    ;
  }
}
