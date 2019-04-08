import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshit_flutter/AppTheme.dart';
import 'package:freshit_flutter/bloc_provider.dart';
import 'package:freshit_flutter/src/blocs/home/HomeBloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final _homeBloc = CustomBlocProvider.of<HomeBloc>(context);
    return StreamBuilder(
      stream: _homeBloc.storedItems,
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("Loading");
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return _buildItem(snapshot.data.documents[index], screenSize);
          },
        );
      },
    );
  }

  Widget _buildItem(DocumentSnapshot item, Size screenSize) {
    String expirePeriod = getExpiresIn(item["expiryDate"]);
    return new Card(
      margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: 0.75,
              child: Image.network(
                item['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
            width: 120,
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 4),
                child: new Text(
                  item['name'],
                  softWrap: true,
                  style: new TextStyle(
                    fontSize: 20,
                    fontFamily: AppTheme.primaryFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                    child: new Text(
                      '${item["quantity"]} ${item["unit"]}',
                      style: new TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 4, 8.0, 4),
                    child: new Text(
                      item["storedIn"],
                      style: new TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
              // TODO : color depending on tags
              Container(
                color: Color.fromRGBO(255, 82, 78, 1.0),
                child: Center(
                  child: Text(
                    item["tags"],
                  ),
                ),
                constraints: BoxConstraints.tight(Size(100, 30)),
                margin: const EdgeInsets.fromLTRB(8.0, 4, 8.0, 4),
              ),
              // Change Date format
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4, 8.0, 4),
                child: Text(
                  'Expires in: $expirePeriod',
                  style: new TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              (expirePeriod != "Expired") ? showButton(screenSize) : Text(""),
            ],
          )
        ],
      ),
    );
  }

  String getExpiresIn(Timestamp t) {
    var diff = t.toDate().difference(DateTime.now());
    print(diff.inDays);
    if (diff.inDays > 0)
      return "${diff.inDays} " + ((diff.inDays == 1) ? "day" : "days");
    else if (diff.inDays <= 0 && diff.inHours > 0)
      return "${diff.inHours} " + ((diff.inHours == 1 ? "hour" : "hours"));
    else if (diff.inHours <= 0 && diff.inMinutes > 0)
      return "${diff.inMinutes} minutes" +
          ((diff.inMinutes == 1 ? "minute" : "minutes"));
    else
      return "Expired";
  }

  Widget showButton(Size screenSize) {
    return Container(
      child: new RaisedButton(
        onPressed: () => null,
        color: AppTheme.primaryColor,
        child: new Text(
          'Used It',
          style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 21,
              letterSpacing: 2,
              color: Colors.white),
        ),
      ),
      width: screenSize.width - 130,
    );
  }
}
