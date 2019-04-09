import 'package:flutter/material.dart';
import 'package:freshit_flutter/Repositories/HomeRepository.dart';
import 'package:freshit_flutter/Repositories/userRepository.dart';
import 'package:freshit_flutter/src/blocs/authentication/AuthenticationBloc.dart';
import 'package:freshit_flutter/src/blocs/authentication/AuthenticationEvent.dart';
import 'package:freshit_flutter/src/blocs/authentication/AuthenticationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '_LoginPageState.dart';
import 'ListsPage.dart';

void main() {
  runApp(MyApp(userRepository: UserRepository()));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;
  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  AuthenticationBloc _authenticationBloc;
  UserRepository get _userRepository => widget.userRepository;
  HomeRepository homeRepository;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(_userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(context.hashCode);
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: new MaterialApp(
        title: 'FreshIt',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationAuthenticated) {
              return ListsPageState(HomeRepository(user: state.user));
            } else if (state is AuthenticationUnauthenticated ||
                state is AuthenticationUninitialized)
              return LoginPage(
                userRepository: _userRepository,
              );
          },
        ),
      ),
    );
  }
}
