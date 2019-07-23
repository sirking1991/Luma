import 'package:Luma/appstate.dart';
import 'package:Luma/productitem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget productTile(
    BuildContext context, ProductItem productItem) {
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
          CachedNetworkImage(
            imageUrl: productItem.imageURL,
            height: 350,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                productItem.name,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
          productItem.productOptions.length != 0 ? productOptions(context, productItem.productOptions) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: new Icon(
                  Icons.star_border,
                  color: Colors.red,
                  size: 35,
                ),
                onPressed: () {
                  print('favorite tapped!');
                },
              ),
              Text(
                "\$" + productItem.price.toString(),
                style: TextStyle(fontSize: 20.0),
              ),
              IconButton(
                icon: new Icon(
                  Icons.add_shopping_cart,
                  color: Colors.red,
                  size: 35,
                ),
                onPressed: () {
                  final appState = Provider.of<AppState>(context);
                  appState.cart.addToCart(productItem);
                  appState.notifyTheListeners();
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

Widget productOptions(BuildContext context, List<ProductOption> productItems) {

}