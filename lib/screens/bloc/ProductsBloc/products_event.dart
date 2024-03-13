import 'package:paras_technologies/screens/model/Product_model.dart';

abstract class ProductsEvent {}

class FetchProducts extends ProductsEvent {}

class ToggleFavorite extends ProductsEvent {
  final Product product;
  final List<Product>? products;
  ToggleFavorite(this.product,this.products);
}