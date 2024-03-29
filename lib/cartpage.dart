import 'package:Luma/appstate.dart';
import 'package:Luma/cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  Cart cart;

  CartPage(this.cart);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
          builder: (_) => AppState(widget.cart),
        ));
  }
}

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Shopping cart"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: () {
              print("Clear cart content");
              appState.cart.clearCart();
              appState.notifyTheListeners();
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
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  CartItem cartItem = appState.cart.cartItems[index];
                  return Dismissible(
                    key: Key(cartItem.productItem.sku),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        appState.cart.removeFromCart(cartItem.productItem,
                            clearAll: true);
                        appState.notifyTheListeners();
                      });
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Item removed")));
                    },
                    child: productCartTile(context, cartItem),
                  );
                },
                itemCount: appState.cart.getCartItems.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget productCartTile(BuildContext context, CartItem cartItem) {
  final appState = Provider.of<AppState>(context);
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(top: 10.0),
    height: 160,
    width: 200,
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    child: Row(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: cartItem.productItem.imageURL,
          height: 350,
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: 180,
              child: Text(
                cartItem.productItem.name,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text("\$" + cartItem.productItem.price.toString(),
                style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      appState.cart.removeFromCart(cartItem.productItem);
                      appState.notifyTheListeners();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Text(
                  cartItem.qty.round().toString(),
                  style: TextStyle(fontSize: 35),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      appState.cart.addToCart(cartItem.productItem);
                      appState.notifyTheListeners();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Text(
                    "\$" +
                        (cartItem.qty * cartItem.productItem.price).toString(),
                    style: TextStyle(fontSize: 35)),
              ],
            )
          ],
        ),
      ],
    ),
  );
}
