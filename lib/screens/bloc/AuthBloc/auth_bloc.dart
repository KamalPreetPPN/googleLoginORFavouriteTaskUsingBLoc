import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignInWithGoogleEvent>((event, emit) async {
      try {
        await _handleGoogleSignIn(emit); // Await the asynchronous operation
      } catch (error) {
        print(error);
      }
    });

    on<SignOutEvent>((event, emit) async {
      try {
        await _handleSignOut(emit); // Await the asynchronous operation
      } catch (error) {
        print(error);
      }
    });
  }

  Future<void> _handleGoogleSignIn(Emitter<AuthState> emit) async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final userCredential = await _auth.signInWithProvider(_googleAuthProvider);
      final User user = userCredential.user!;
      emit(AuthenticatedState(user));
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut(Emitter<AuthState> emit) async {
    try {
      await _auth.signOut();
      emit(UnauthenticatedState());
    } catch (error) {
      print(error);
    }
  }
}
