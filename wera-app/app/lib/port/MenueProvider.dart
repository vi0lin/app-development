import 'package:flutter/cupertino.dart';


class MenueProvider extends StatefulWidget {

  final Widget child;
  final Widget menue;
  // const MenueProvider({
  //   Key key,
  //   @required this.child,
  // }) : super(key: key);
  MenueProvider({this.child, this.menue});
  // Widget menue;
  // MenueProvider(Widget menue) {
  //   this.menue = menue;
  // }

  static _MenueProviderState of(BuildContext context) {
    //   //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_MenueProviderData>().data;
    // return (context.ancestorWidgetOfExactType(_MenueProviderData) as _MenueProviderData).data;
    //return context.getElementForInheritedWidgetOfExactType<_MenueProviderData>();
  }

  @override
  _MenueProviderState createState() => _MenueProviderState();
}


class _MenueProviderData extends InheritedWidget {
  final _MenueProviderState data;
  _MenueProviderData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key/*, child: child*/);

  @override
  bool updateShouldNotify(_MenueProviderData old) => true;
}

class _MenueProviderState extends State<MenueProvider> with WidgetsBindingObserver  {
  @override
  Widget build(BuildContext context) {
    //throw child;
    return widget.child;
  }  
}