import 'package:flutter/material.dart';

class WeraAppTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 7, right: 7, top: 48, bottom: 7),
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                textarea.setMode(EditMode.Text);
              },
              child: Text(
                "T",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Text(" "),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                textarea.setMode(EditMode.Chords);
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
        textarea,
      ],
      ),
    );
      /*
      MaterialApp(
      home: DefaultTabController(
            length: choices2.length,
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                title: const Text('Lobpreis'),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: choices2.map((Choice2 choice) {
                    return Tab(
                      text: choice.title,
                      icon: Icon(choice.icon),
                    );
                  }).toList(),
                ),
              ),
              body: TabBarView(
                children: choices2.map((Choice2 choice) {
                  return Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: ChoiceCard2(choice: choice),
                  );
                }).toList(),
              ),
            ),
          ),
    );*/
  }
}

class SongEditField extends StatelessWidget {
  TextField tf = new TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
      );

  Text getValue() {
    return new Text(this.tf.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: tf,
    );
  }
}


enum EditMode {
  Text,
  Chords
}
TextAreaModeWrapper textarea = new TextAreaModeWrapper();
class TextAreaModeWrapper extends StatelessWidget {
  //const ChoiceCard2({Key key, this.choice}) : super(key: key);
  SongEditField textarea = new SongEditField();
  EditMode mode;
  Text text;

  setMode(EditMode mode) {
    this.mode = mode;
    text = textarea.getValue();
  }

  @override
  Widget build(BuildContext context) {
    //final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Container(
      child: this.mode == EditMode.Text ? textarea : text
    );
  }
}