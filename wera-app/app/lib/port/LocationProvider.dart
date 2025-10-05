import 'package:flutter/material.dart';

class LocationProvider extends StatefulWidget {

  Widget page;

  final Widget child;
  LocationProvider({this.child});
  // const LocationProvider({
  //   Key key,
  //   @required this.child,
  // }) : super(key: key);
  // Widget menue;
  // LocationProvider(Widget menue) {
  //   this.menue = menue;
  // }

  static _LocationProviderState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_LocationProviderData>().data;
    //return (context.ancestorWidgetOfExactType(_LocationProviderData) as _LocationProviderData).data;
  }

  @override
  _LocationProviderState createState() => _LocationProviderState();
}


class _LocationProviderData extends InheritedWidget {
  final _LocationProviderState data;
  _LocationProviderData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key/*, child: child*/);

  @override
  bool updateShouldNotify(_LocationProviderData old) => true;
}

class _LocationProviderState extends State<LocationProvider> with WidgetsBindingObserver  {
  void setPage(Widget page) {
    setState(() {
      this.widget.page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }  
}