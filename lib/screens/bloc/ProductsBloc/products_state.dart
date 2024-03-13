import 'package:paras_technologies/screens/model/Product_model.dart';

abstract class ProductsState {
}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<Product> favoriteProducts;
  ProductsLoaded(this.products,{required this.favoriteProducts});
}

class FavoriteProductsChanged extends ProductsState {
  final List<Product> favoriteProducts;
  FavoriteProductsChanged(this.favoriteProducts);
}

class ProductsError extends ProductsState {
  final String error;
  ProductsError(this.error);
}