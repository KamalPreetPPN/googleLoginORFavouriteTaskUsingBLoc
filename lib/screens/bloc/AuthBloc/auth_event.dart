part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  @override
  List<Object> get props=>[];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
