import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_technologies/screens/Splash_screen/splash_screen.dart';
import 'package:paras_technologies/screens/bloc/AuthBloc/auth_bloc.dart';
import 'package:paras_technologies/screens/bloc/ProductsBloc/products_bloc.dart';
import 'package:paras_technologies/screens/google_login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_)=>AuthBloc()),
        BlocProvider<ProductsBloc>(create: (_)=>ProductsBloc()),
    ],
        child:    MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        )
    );
      

  }
}
