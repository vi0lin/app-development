import 'dart:convert';

import 'package:app/port/utils/weraStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../../utils/Network.dart';
import '../AdminFunctions.dart';
import '../User.dart';

class AdminChatModel {
   TextEditingController messagebox;
}

class _AdminChatData extends InheritedWidget {
  final _AdminChatState data;
  _AdminChatData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_AdminChatData old) => true;
}

class AdminChat extends StatefulWidget {

  final channel = IOWebSocketChannel.connect('{WERA_APP_API}');

  final List<Widget> list = new List<Widget>();

  static _AdminChatState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_AdminChatData>().data;
  }
  
  @override
  _AdminChatState createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {

  AdminChatModel model;

  Widget icon = ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(width: 1, style: BorderStyle.solid),
        image: DecorationImage(
          fit: BoxFit.cover,
          //image: AssetImage('img/abstractBackgrounds/'+Random().nextInt(9).toString()+'.jpg')
          image: AssetImage('img/abstractBackgrounds/1.jpg')
        ),
      ),
      child: Center(child: Text("W", style: textStyleTextWhiteBig)),
    )
  );


  Widget incomingMessage(String text) {
    return Expanded(child: Row(children: [ Expanded(child: Padding(padding: EdgeInsets.only(left: 10, right: 10), child: Text(text, textAlign: TextAlign.right,))), icon ]));
  }

  Widget outgoingMessage(String text) {
    return Expanded(child: Row(children: [ icon, Expanded(child: Padding(padding: EdgeInsets.only(left: 10, right: 10), child: new Text(text))) ]));
  }

  @override
  void initState() {
    super.initState();
    if(this.model == null)
      this.model = new AdminChatModel();

    if(this.model.messagebox == null)
       this.model.messagebox =  TextEditingController();

    widget.channel.stream.listen((event) {
      setState(() {
        widget.list.insert(0, incomingMessage(event));
        //print("message: " + event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildHomeScreen(context);
  }

  void _sendMessage() {
    widget.channel.sink.add(json.encode({"action": "message", "message": model.messagebox.text}));
    widget.list.insert(0, outgoingMessage(model.messagebox.text));
    model.messagebox.text = "";
  }

  Widget buildHomeScreen(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.black87,
    //     title: Text('Admin Chat'),
    //   ),
    //   body: Container(
    //     height: 200,
    //     padding: EdgeInsets.only(left: 10, right: 10),
    //     child: Center(
    //       child: SingleChildScrollView(child: ListView.builder(scrollDirection: Axis.vertical, shrinkWrap: true, itemCount: widget.list.length, itemBuilder: (BuildContext context, int index) { return widget.list[index]; })),
    //     ),
    //   ),
    //   bottomNavigationBar: Row(children: [
    //     TextField(controller: model.messagebox, onSubmitted: (str) { _sendMessage(); } ,),
    //     FlatButton(onPressed: () { _sendMessage(); }, child: Icon(Icons.send, semanticLabel: "Send Message",),),
    //     FlatButton(onPressed: () { channel.sink.add(json.encode({"action": "plus" })); }, child: Icon(Icons.plus_one, semanticLabel: "Plus",),),
    //     FlatButton(onPressed: () { channel.sink.add(json.encode({"action": "minus"})); },  child: Icon(Icons.wrap_text, semanticLabel: "Minus",),),
    //   ],),
    // );
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //ListView.builder(scrollDirection: Axis.vertical, itemCount: widget.list.length, itemBuilder: (BuildContext context, int index) { return widget.list[index]; }),
          //Expanded(child: ListView(reverse: true, scrollDirection: Axis.vertical, shrinkWrap: true, children: widget.list)),
          Expanded(child: ListView.builder(reverse: true, shrinkWrap: true, scrollDirection: Axis.vertical, itemCount: widget.list.length, itemBuilder: (BuildContext context, int index) { return widget.list[index]; })),
          Row(children: [
            Expanded(child: TextField(
              style: textStyleLightSmall,
              controller: this.model.messagebox,
              keyboardType: TextInputType.text,
              maxLines: null,
              decoration: new InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: weraVerylightgray)), hintText: "Nachricht", contentPadding: const EdgeInsets.only(top: 0,bottom:0,left: 7, right: 7)),
              onChanged: (txt) { setState(() {  }); },
              onTap: () { setState(() {  }); },
              onEditingComplete: () {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                });
              },
            )),
            FlatButton(onPressed: () { _sendMessage(); }, child: Icon(Icons.send, semanticLabel: "Send Message",),),
          ],)
                // Row(children: [
                //   FlatButton(onPressed: () { channel.sink.add(json.encode({"action": "plus" })); }, child: Icon(Icons.plus_one, semanticLabel: "Plus",),),
                //   FlatButton(onPressed: () { channel.sink.add(json.encode({"action": "minus"})); },  child: Icon(Icons.wrap_text, semanticLabel: "Minus",),),
                // ],
          ]
      )
    );
  }
}
