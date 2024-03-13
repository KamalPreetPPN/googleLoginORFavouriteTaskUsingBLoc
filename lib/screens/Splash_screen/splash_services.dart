import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paras_technologies/screens/google_login_page.dart';
import 'package:paras_technologies/screens/products_page.dart';

class SplashServices{

  IsLogin(BuildContext context){
   final auth = FirebaseAuth.instance;
   final user = auth.currentUser;



   Timer(Duration(seconds: 2), () {
     if(user !=null){
       Navigator.push(context, MaterialPageRoute(builder: (context){
         return ProductsPage();
       }));
     }else{
       Navigator.push(context, MaterialPageRoute(builder: (context){
         return GoogleLoginPage();
       }));
     }
   });

 }

 // handleAuthState(){
 //   return StreamBuilder(
 //       stream: FirebaseAuth.instance.authStateChanges(),
 //       builder: (BuildContext context, snapshot){
 //         if(snapshot.hasData){
 //           return InitialPage();
 //         }else{
 //           return SplashScreen();
 //         }
 //       }
 //   );
 // }

 // void IsLoginSaved()async{
 //   final auth = FirebaseAuth.instance;
 //   final user = auth.currentUser;
 //
 //   Future<SharedPreferences> sp = SharedPreferences.getInstance();
 //
 // }

}