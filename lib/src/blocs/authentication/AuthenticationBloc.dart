import 'package:bloc/bloc.dart';
import 'package:freshit_flutter/src/blocs/authentication/AuthenticationEvent.dart';
import 'package:freshit_flutter/src/blocs/authentication/AuthenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = true;
      if (hasToken)
        yield AuthenticationAuthenticated();
      else
        yield AuthenticationUnauthenticated();
    }
    
    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationUnauthenticated();
    }
  }
}
