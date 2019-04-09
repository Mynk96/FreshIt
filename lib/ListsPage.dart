import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshit_flutter/AddItemScreen.dart';
import 'package:freshit_flutter/AppTheme.dart';
import 'package:freshit_flutter/BottomNav.dart';
import 'package:freshit_flutter/HomePage.dart';
import 'package:freshit_flutter/bloc_provider.dart';
import 'package:freshit_flutter/src/blocs/authentication/AuthenticationBloc.dart';
import 'package:freshit_flutter/src/blocs/authentication/AuthenticationEvent.dart';
import 'package:freshit_flutter/src/blocs/home/HomeBloc.dart';
import 'package:freshit_flutter/src/blocs/home/HomeRepository.dart';

class ListsPageState extends StatefulWidget {
  final HomeRepository homeRepository;
  ListsPageState(this.homeRepository);

  @override
  State<StatefulWidget> createState() {
    return ListsPage();
  }
}

class ListsPage extends State<ListsPageState> {
  HomeBloc _homeBloc;
  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(widget.homeRepository);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBlocProvider(
      bloc: _homeBloc,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddItem(_homeBloc))),
          tooltip: 'Add Item',
          child: Icon(Icons.add),
          elevation: 2.0,
          backgroundColor: Color.fromRGBO(238, 238, 238, 1.0),
          foregroundColor: Colors.black,
        ),
        appBar: new AppBar(
          title: new Text(
            "FreshIt",
            style: new TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal),
          ),
          backgroundColor: Color.fromRGBO(23, 69, 145, 1.0),
          actions: <Widget>[
            IconButton(
              icon: new Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                _homeBloc.cancelAllNotifications();
                BlocProvider.of<AuthenticationBloc>(context)
                    .dispatch(LoggedOut());
              },
              tooltip: "Logout",
            )
          ],
        ),
        body: StreamBuilder(
          stream: _homeBloc.selectedPage,
          initialData: HomePage(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Loading");
            return snapshot.data;
          },
        ),
        bottomNavigationBar: BottomNav(
          color: Colors.white,
          selectedColor: Colors.red,
          items: [
            BottomNavItem(Icons.home, 'Home'),
            BottomNavItem(Icons.settings, 'Settings'),
          ],
          backgroundColor: Colors.blue,
          onTabSelected: (int i) => _homeBloc.pageIndexSubject.add(i),
        ),
      ),
    );
  }
}
