class ProductItem {
  String sku;
  String name;
  String imageURL;
  double price;
  List<ProductOption> productOptions;



  ProductItem(this.sku, this.name, this.imageURL, this.price, this.productOptions);
}

class ProductOption {
  int id;
  String label;
  int position;
  List<OptionValue> values;

  ProductOption(this.id, this.label, this.position, this.values);
}

class OptionValue {
  String label;
  int value;

  OptionValue(this.label, this.value);
}