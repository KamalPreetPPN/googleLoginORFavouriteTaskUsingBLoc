import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:paras_technologies/screens/google_login_page.dart';
import 'package:paras_technologies/screens/model/Product_model.dart';
import 'package:paras_technologies/screens/bloc/AuthBloc/auth_bloc.dart';
import 'package:paras_technologies/screens/bloc/ProductsBloc/products_bloc.dart';
import 'package:paras_technologies/screens/bloc/ProductsBloc/products_event.dart';
import 'package:paras_technologies/screens/bloc/ProductsBloc/products_state.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    context.read<ProductsBloc>().add(FetchProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build products page');
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () async {
            context.read<AuthBloc>().add(SignOutEvent());
            await Future.delayed(Duration.zero);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return GoogleLoginPage();
            }),(route)=>false);
          },
          child: Icon(Icons.logout_outlined),
        ),
        title: Text('Products List'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              return BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProductsLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Favorite Products',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                        FavoriteProductsList(favoriteProducts: state.favoriteProducts,allproducts: state.products),
                        SizedBox(height: 20,),
                        Divider(),
                        SizedBox(height: 20,),
                        Text('All Products',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                        Expanded(
                          child: ProductsList(products: state.products,favoriteProducts:state.favoriteProducts),
                        ),
                      ],
                    );
                  } else if (state is ProductsError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is FavoriteProductsChanged) {
                    // Handle the favorite products list state here
                    return Column(
                      children: [
                        Expanded(
                          child: FavoriteProductsList(
                            favoriteProducts: state.favoriteProducts,
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              );
            } else if (state is UnauthenticatedState) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }
}


//all products list
class ProductsList extends StatelessWidget {
  final List<Product> products;
  final List<Product>? favoriteProducts;
  const ProductsList({Key? key, required this.products,this.favoriteProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> sortedProducts = [];
    // Add favorite products to the sorted list
    if (favoriteProducts != null && favoriteProducts!.isNotEmpty) {
      sortedProducts.addAll(favoriteProducts!);
    }

    // Add non-favorite products to the sorted list
    for (var product in products) {
      if (!(favoriteProducts?.contains(product) ?? false)) {
        sortedProducts.add(product);
      }
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = sortedProducts[index];
        final isFavorite = favoriteProducts?.contains(product) ?? false;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              product.thumbnail,
            ),
          ),
          title: Text('${product.title}'),
          subtitle: Text('${product.description}'),
          trailing: IconButton(
            icon: isFavorite ? Icon(Icons.favorite,color: Colors.red,): Icon(Icons.favorite_border),
            onPressed: () {
              context.read<ProductsBloc>().add(ToggleFavorite(product,products));
            },
          ),
        );
      },
    );
  }
}


//favourite products list
class FavoriteProductsList extends StatelessWidget {
  final List<Product>? favoriteProducts;
  final List<Product>? allproducts;

  const FavoriteProductsList({Key? key, this.favoriteProducts,this.allproducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: favoriteProducts?.length!=0 ? ListView.builder(
        itemCount: favoriteProducts?.length ?? 0,
        itemBuilder: (context, index) {
          final products = allproducts;
          final product = favoriteProducts![index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                product.thumbnail,
              ),
            ),
            title: Text('${product.title}'),
            subtitle: Text('${product.description}'),
            trailing: IconButton(
              icon: Icon(Icons.delete,color: Colors.red,),
              onPressed: () {
                context.read<ProductsBloc>().add(ToggleFavorite(product,products));
              },
            ),
          );
        },
      ) :
      Center(child: Text('Favorite products shown here'),),
    );
  }
}
