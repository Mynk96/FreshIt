import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]): super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() {
    return "AppStartedEvent";
  }
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() {
    return "LoggedInEvent";
  }
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() {
    return "LoggedOutEvent";
  }
}
