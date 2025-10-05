import 'package:app/port/utils/weraStyle.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final IconData icondata;
  final String subcaption;
  final Function onPressed;
  const MyButton(this.icondata, this.subcaption, this.onPressed, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 20,
      height: 10.0,
      child: FlatButton(
        padding: EdgeInsets.all(3.0),
        child: 
          Column(
            children:[
            Icon(this.icondata),
            Text(this.subcaption, style: textStyleSmall)
          ]),
        onPressed: onPressed,
      )
    );
  }
}
    //     Icon(Icons.cloud_download), onPressed: () {
    //       API1.requestNode().then((n) {
    //         // Iterable n = jsonDecode(n.body);
    //         //Map.fromEntries(n , key: (e) => e, value: (e) => nodeWidget(e));
    //         Map<Serializable, Widget> m = Map.fromIterable(n.values, key: (e) => e, value: (e) => nodeWidget(e));
    //         setState(() {
    //           this.widget.map.addAll(m);
    //         });

    // }); }