import 'package:cale_nt/calendar_actions.dart';
import 'package:flutter/material.dart';

const blc = Colors.black;
main() {
  runApp(MaterialApp(
      theme: ThemeData(
          primaryColor: blc,
          canvasColor: blc,
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
          inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white54))),
      builder: (context, child) => ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          ),
      home: HomeScreen()));
}

class MyBehavior extends ScrollBehavior {
  buildViewportChrome(context, child, axisDirection) => child;
}

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title;
  build(context) {
    return Scaffold(
        backgroundColor: blc,
        appBar: AppBar(title: Text("Events"), centerTitle: true),
        body: _listView(),
        floatingActionButton: _floatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  FloatingActionButton _floatingActionButton(context) =>
      FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.add),
          label:
              Text("ADD EVENT", style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => _settingModalBottomSheet(context));

  _listView() => FutureBuilder(
        future: getCalendarEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    EventListComponent(snapshot.data[index]));
          else
            return CircularProgressIndicator();
        },
      );

  void _settingModalBottomSheet(context) {
    final a = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            padding: EdgeInsets.fromLTRB(
                20, 10, 20, MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                TextField(
                    controller: a,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(hintText: 'New Event')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      child:
                          Text("Save", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        addCalendarEvents(
                            title: a.text, startDate: DateTime.now());
                        Navigator.pop(context);
                        setState(() {});
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}

class EventListComponent extends StatelessWidget {
  final item;
  EventListComponent(this.item);
  build(context) {
    return Dismissible(
        background: Container(color: Colors.redAccent),
        key: Key(item.eventId),
        onDismissed: (direction) {
          deleteCaldendarEvents(item.eventId);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Text(
            item.title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ));
  }
}
