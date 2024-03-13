// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:paras_technologies/screens/products_page.dart';
// import 'package:sign_in_button/sign_in_button.dart';
//
// class GoogleLoginPage extends StatefulWidget {
//   const GoogleLoginPage({super.key});
//
//   @override
//   State<GoogleLoginPage> createState() => _GoogleLoginPageState();
// }
//
// class _GoogleLoginPageState extends State<GoogleLoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   User? _user;
//
//   @override
//   void initState() {
//     super.initState();
//     _auth.authStateChanges().listen((event) {
//       setState(() {
//         _user = event;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Google SignIn"),
//       ),
//       body: _googleSignInButton(),
//     );
//   }
//
//   Widget _googleSignInButton() {
//     return Center(
//       child: SizedBox(
//         height: 50,
//         child: SignInButton(
//           Buttons.google,
//           text: "Sign up with Google",
//           onPressed: _handleGoogleSignIn,
//         ),
//       ),
//     );
//   }
//
//   Widget _userInfo() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(_user!.photoURL!),
//               ),
//             ),
//           ),
//           Text(_user!.email!),
//           Text(_user!.displayName ?? ""),
//           MaterialButton(
//             color: Colors.red,
//             child: const Text("Sign Out"),
//             onPressed: _auth.signOut,
//           )
//         ],
//       ),
//     );
//   }
//
//   void _handleGoogleSignIn() {
//     try {
//       GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
//       _auth.signInWithProvider(_googleAuthProvider).then((value){
//         Navigator.push(context, MaterialPageRoute(builder: (context){
//           return ProductsPage();
//         }));
//       });
//     } catch (error) {
//       print(error);
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_technologies/screens/bloc/AuthBloc/auth_bloc.dart';
import 'package:paras_technologies/screens/products_page.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleLoginPage extends StatelessWidget {
  const GoogleLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            return Container(
              height: 60,
              child: SignInButton(
                Buttons.google,
                text: "Sign up with Google",
                onPressed: () {
                  context.read<AuthBloc>().add(SignInWithGoogleEvent());
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
