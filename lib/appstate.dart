import 'package:Luma/main.dart';
import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  AppState();

  List<ProductItem> _productDisplayList = [];

  void addProductList(ProductItem productItem) {
    _productDisplayList.add(productItem);
    notifyListeners();
  }

  void clearProductList() {
    _productDisplayList.clear();
    notifyListeners();
  }

  int get getProductCount => _productDisplayList.length;

  List<ProductItem> get getProductDisplayList => _productDisplayList;
}