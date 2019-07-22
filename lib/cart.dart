import 'package:Luma/productitem.dart';

class Cart {

  // Shopping cart
  List<CartItem> cartItems = [];    

  Cart() {
    // TODO: We need persist cart content so we can get back to it later
  }


  double getCartItemCount() {
    double count = 0;
    for(var i=0; i<cartItems.length; i++) {
      count += cartItems[i].qty;
    }
    return count;
  }

  void addToCart(ProductItem productItem) {
    // search for the item from cartItems, +1 to its qty if found, else add the productItem with qty=1
    int itemIndex = -1;
    for(var i=0; i<cartItems.length; i++) {
      if (cartItems[i].productItem.sku==productItem.sku) {
        cartItems[i].qty++;
        itemIndex = i;
        break;
      }
    }
    if (itemIndex == -1) cartItems.add(new CartItem(productItem, 1.0));
    print(cartItems);
  }

  void removeFromCart(ProductItem productItem, {bool clearAll: false}) {
    // search for the item from cartItems, -1 to its qty if found, else do nothing
    int itemIndex = -1;
    for(var i=0; i<cartItems.length; i++) {
      if (cartItems[i].productItem.sku==productItem.sku) {
          cartItems[i].qty--;
          itemIndex = i;
        break;
      }
    }
    if ((itemIndex >= 0 && cartItems[itemIndex].qty<=0) || clearAll) {
      cartItems.removeAt(itemIndex);
    }
    print(cartItems);
  }

  double getCartTotal() {
    double total = 0;
    for(var i=0; i<cartItems.length; i++) {
      total += cartItems[i].productItem.price * cartItems[i].qty;
    }
    return total;
  }

  void clearCart() {
    cartItems.clear();
  }

  List<CartItem> get getCartItems => cartItems;
}


class CartItem {
  ProductItem productItem;
  double qty;

  CartItem(this.productItem, this.qty);
}