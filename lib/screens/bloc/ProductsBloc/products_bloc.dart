import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_technologies/screens/model/Product_model.dart';
import 'package:paras_technologies/screens/bloc/ProductsBloc/products_event.dart';
import 'package:paras_technologies/screens/bloc/ProductsBloc/products_state.dart';
import 'package:http/http.dart' as http;

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  List<Product> favoriteProducts = [];
  ProductsBloc() : super(ProductsLoading()) {

    on<FetchProducts>((event, emit) async {
      try {
        final List<Product> products = await getData();
        emit(ProductsLoaded(products,favoriteProducts: favoriteProducts));
      } catch (e) {
        emit(ProductsError('Failed to fetch products'));
      }
    });

    on<ToggleFavorite>((event, emit) {
      final product = event.product;
      final Products =event.products;
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
      emit(ProductsLoaded(Products!,favoriteProducts: List.of(favoriteProducts)));
    });

  }


//method to fetch data from api
  Future<List<Product>> getData() async {
    final response =
    await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['products'] is List) {
        List<dynamic> productList = jsonData['products'];
        List<Product> products =
        productList.map((item) => Product.fromJson(item)).toList();
        return products;
      } else {
        throw Exception('Invalid response data');
      }
    } else {
      throw Exception('Failed to fetch products');
    }
  }

}