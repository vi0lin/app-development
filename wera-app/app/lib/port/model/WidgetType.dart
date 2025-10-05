import 'dart:convert';

import 'package:app/port/utils/DBProvider.dart';

class WidgetType extends Serializable with DataClass<WidgetType>, DBSProvider<WidgetType> {
  int idWidgetType;
  String name;
  WidgetType({
    this.idWidgetType,
    this.name,
  }) : super(idWidgetType);

  // WidgetType copyWith({
  //   int idWidgetType,
  //   String name,
  // }) {
  //   return WidgetType(
  //     idWidgetType: idWidgetType ?? this.idWidgetType,
  //     name: name ?? this.name,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'idWidgetType': idWidgetType,
      'name': name,
    };
  }

  factory WidgetType.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return WidgetType(
      idWidgetType: map['idWidgetType'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WidgetType.fromJson(String source) => WidgetType.fromMap(json.decode(source));

  @override
  String toString() => 'WidgetType(idWidgetType: $idWidgetType, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is WidgetType &&
      o.idWidgetType == idWidgetType &&
      o.name == name;
  }

  @override
  int get hashCode => idWidgetType.hashCode ^ name.hashCode;


  @override
  List<String> memberNames() {
    return ["idWidgetType", "name"];
  }

  @override
  String tableName() {
    return "WidgetType";
  }

  @override
  String createStatement() {
    return '''
      create table '''+tableName()+''' ( 
        idWidgetType integer null, 
        name varchar(50) null
      )
    ''';
  }  
}
