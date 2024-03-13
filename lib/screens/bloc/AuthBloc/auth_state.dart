part of 'auth_bloc.dart';

@immutable
abstract class AuthState {

}

class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState(this.user);
}

class UnauthenticatedState extends AuthState {}


