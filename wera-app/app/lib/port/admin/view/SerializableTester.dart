import 'dart:math';

import 'package:app/port/model/Node.dart';
import 'package:app/port/model/WidgetType.dart';
import 'package:app/port/model/TestNode.dart';
import 'package:app/port/utils/DBProvider.dart';
import 'package:app/port/utils/config.dart';
import 'package:app/port/widgets/MyButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/Network.dart';

class SerializableTesterModel {
   TextEditingController messagebox;
}

class _SerializableTesterData extends InheritedWidget {
  final _SerializableTesterState data;
  _SerializableTesterData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_SerializableTesterData old) => true;
}

class SerializableTester extends StatefulWidget {

  List<WidgetType> widgetType = new List<WidgetType>();
  SerializableTester() {
    Node().initDatabase();
    WidgetTypeEnum.values.forEach((element) {
      WidgetType w = WidgetType(idWidgetType: element.index, name: element.toString());
      w.save();
      this.widgetType.add(w);
    });
  }

  Map<Node, Widget> map = new Map<Node, Widget>();

  static _SerializableTesterState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_SerializableTesterData>().data;
  }

  @override
  _SerializableTesterState createState() => _SerializableTesterState();
}

class _SerializableTesterState extends State<SerializableTester> {

  SerializableTesterModel model;

  @override
  void initState() {
    super.initState();
    if(this.model == null)
      this.model = new SerializableTesterModel();

    if(this.model.messagebox == null)
       this.model.messagebox =  TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: buildHomeScreen(context)
        ),
      ),
    );
  }
  Widget siteWidget(Node t) {
    return Text("TEXT");
  }
  Widget textWidget(Node t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(t.toString()),
        Container(
          height: 50,
          //width: 200,
          child: ListView(
          // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Row(children: [
              MyButton(Icons.edit, "modify, save",
                () { setState(() {
                  t.jsonData+="."; t.save().then((i) { t.loadAll().then((value) { reload(value); }); });
                });
              }),
              MyButton(Icons.edit, "modify",
                () { setState(() {
                  t.jsonData+="."; t.loadAll().then((value) { reload(value); });
                });
              }),
              MyButton(Icons.save, "save local",
                () {
                  t.save();
                  setState(() {
                    this.widget.map[t] = textWidget(t);
                  });
                }
              ),
              MyButton(Icons.delete_forever, "delete",
                () { setState(() {
                  t.delete(); t.loadAll().then((value) => reload(value));
                });
              }),
              MyButton(Icons.cloud_upload, "upload",
                () {
                  setState(() {
                    t.upload(null).then((value) {
                      t.id = value.id;
                      // var a = this.widget.map[t];
                      // this.widget.map[t] = null;
                      // this.widget.map[t] = a;
                      List<Node> clone = new List<Node>();
                      clone.addAll(this.widget.map.keys);
                      reload(clone);
                      //t = value;
                      // this.widget.map.remove(t);
                      
                      // this.widget.map.update(t, (v) => v);
                      // this.widget.map[t]=textWidget(t);
                      // print(value);
                      //t.idNode = value.idNode;
                    });
                  });
                }),
              MyButton(Icons.cloud_download, "download",
                () { 
                  t.download(t.idNode).then((value) { setState(() { print(value); }); });
                }
              ),
              MyButton(Icons.cloud_download, "update in Local DB",
                () { 
                  t.updateLocal().then((value) { setState(() { print(value); }); });
                }
              ),
            ],)
          ])
        )
      ]);
  }
  Widget paymentWidget(Payment t) {
    return Text(t.idPayment.toString());
  }

  Widget list() {
    return ListView.builder(
      // Need to display a loading tile if more items are coming
      itemCount: this.widget.map.length,
      itemBuilder: (BuildContext context, int index) {
        return this.widget.map.values.elementAt(index);
      },
    );
  }

  Widget list2() {
    return ListView(children: this.widget.map.values);
  }

  void reload(dynamic n) {
    setState(() {
      this.widget.map.clear();
      if (n != null) {
        //print(n);
        // Map<Serializable, Widget> m = Map.fromIterable(n, key: (e) => e, value: (e) => textWidget(e));
        Map<Node, Widget> m = Map.fromIterable(n,
          key: (e) => e,
          value: (e) {
            print(e);
            if(e.runtimeType == Node) {
              return createRightWidgetFrom(e);
              // return textWidget(e);
              }
              else return paymentWidget(e);
            } );
          //this.widget.map.putIfAbsent(m, (m) => );
          //this.widget.map.updateAll((n, w) => n.w; );
          //F for (var element in this.widget.map.keys) {
          //A   this.widget.map.keys.firstWhere((e) => e.idNode == element.idNode). = element;
          //K }
          //E N E W S
          //Set.from(this.widget.map.keys).map((e) => (item) => item == 1 ? 0 : item)
          this.widget.map.addAll(m);
          //this.widget.map.updateAll((n,w) { return ; });
          //this.widget.map.updateAll((key, value) => null);
          // for ( var i in this.widget.map.keys) {
          //   this.widget.map.removeWhere((key, value) => key.idNode == i.idNode);
          //   this.widget.map.add
          // }
      }
      else {

        print("nothing found.");
      }
      
    });
  }

  Widget buildHomeScreen(BuildContext context) {
    return Column(children: [
      Row(children: [
        Column(children: [
          MyButton(Icons.add, "Create Node element",
            () {
                Node node = new Node(idNode: null, fiWidgetType: 1, jsonData: "Node");
                setState(() {
                  this.widget.map[node] = textWidget(node);
                  //this.widget.map.keys.firstWhere((element) => element==node);
                });
            }
          ),
          MyButton(Icons.add, "Create Payment element.",
            () {
              setState(() {
                Payment payment = new Payment(idPayment: Random().nextInt(2000));
                payment.save();
                //this.widget.map[payment] = paymentWidget(payment);
              });
            }
          ),
        ],),
        Column(children: [
          MyButton(Icons.save, "save all", () {
            setState(() {
              this.widget.map.forEach((key, value) { key.jsonData += "."; key.save(); });
            });
          },),
          //FlatButton(child: Icon(Icons.delete), onPressed: () { print("pressed"); },),
          MyButton(Icons.file_download, "load all", () {

            Node().loadAll().then(
              (n) {
                setState(() {
                  reload(n);
                });
              }
            ); },),
            MyButton(Icons.cloud_download, "Download all", () { 
              API1.requestNode().then((n) {
                // Iterable n = jsonDecode(n.body);
                //Map.fromEntries(n , key: (e) => e, value: (e) => textWidget(e));
                Map<Serializable, Widget> m = Map.fromIterable(n.values, key: (e) => e, value: (e) => textWidget(e));
                setState(() {
                  this.widget.map.addAll(m);
                });
            }); }),
            MyButton(Icons.clear, "Clear List",
              () { 
                setState(() {
                  this.widget.map.clear();
                });
              }
            ),
            MyButton(Icons.save, "upload all", () {
              setState(() {
                this.widget.map.forEach((key, value) { key.jsonData += "."; key.save(); });
              });
            },),
            MyButton(Icons.delete, "Delete /app.db Database",
              () { 
                Node().dropDatabase();
              }
            ),
            MyButton(Icons.create, "Open/Create /app.db Database",
              () { 
                Node().initDatabase();
              }
            ),
          ],),
        ]),
        Expanded(child: Container(height: 200, child: list())),
      ],);
    }
  
    Widget createRightWidgetFrom(dynamic e) {
      WidgetType widgetType = this.widget.widgetType.firstWhere((element) => element.idWidgetType == e.fiWidgetType);
      WidgetTypeEnum widgetEnum = WidgetTypeEnum.values.where((element) => element.toString() == widgetType.name).first;
      switch(widgetEnum) {
        case WidgetTypeEnum.site: {
          return siteWidget(e);
        } break;
        case WidgetTypeEnum.text: {
          return textWidget(e);
        }break;
        case WidgetTypeEnum.image:{
          return paymentWidget(e);
        }break;
        default: {
          return Text("NO WIDGET CREATED...");
        } break;
      }
    }
}