
import 'package:Luma/cart.dart';
import 'package:Luma/productitem.dart';
import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  
  List<ProductItem> _productDisplayList = []; // List of products to display

  Cart cart = new Cart();

  AppState(Cart cart) {
    if (cart != null) {
      this.cart = cart;
    }
  }

  void notifyTheListeners() => notifyListeners();

  void addProductList(ProductItem productItem) => _productDisplayList.add(productItem);    

  void clearProductList() {
    _productDisplayList.clear();
    notifyTheListeners();
  }

  int get getProductCount => _productDisplayList.length;

  List<ProductItem> get getProductDisplayList => _productDisplayList;
  
}

