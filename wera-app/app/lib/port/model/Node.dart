import 'dart:convert';

import 'package:app/port/utils/DBProvider.dart';

class Node extends Serializable with DataClass<Node>, DBSProvider<Node> {
  int idNode;
  int fiWidgetType;
  String jsonData;

  // int get id {
  //   return super.id;
  // }

  set id(int id) {
    super.id = id;
    idNode = id;
  }

  Node({this.idNode, this.fiWidgetType, this.jsonData}) : super(idNode);

  Node copyWith({
    int idNode,
    int fiWidgetType,
    String jsonData,
  }) {
    return Node(
      idNode: idNode ?? this.idNode,
      fiWidgetType: fiWidgetType ?? this.fiWidgetType,
      jsonData: jsonData ?? this.jsonData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idNode': idNode,
      'fiWidgetType': fiWidgetType,
      'jsonData': jsonData,
    };
  }

  // factory Node.fromMap(Map<String, dynamic> map) {
  //   if (map == null) return null;
  
  //   return Node(
  //     idNode: map['idNode'],
  //     fiWidgetType: map['fiWidgetType'],
  //     jsonData: map['jsonData'],
  //   );
  // }

  Node fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Node(
      idNode: map['idNode'],
      fiWidgetType: map['fiWidgetType'],
      jsonData: map['jsonData'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory Node.fromJson(String source) => Node.fromMap(json.decode(source));

  Node fromJson(String source) => fromMap(json.decode(source));

  // Node fromJson(String jsonString) {
  //   // Iterable l = jsonDecode(jsonString);
  //   return l.first;
  //   /*var list = (l as List).map((i) => Node.fromJson(i)).toList();
  //   Map<String, dynamic> json = jsonDecode(jsonString);
  //   return Node(
  //     idNode: json['id'],
  //     fiWidgetType: json['fiWidgetType'],
  //     jsonData: json['jsonData']!=null?json['jsonData']:""
  //   );*/
  // }

  @override
  String toString() => 'Node(idNode: $idNode, fiWidgetType: $fiWidgetType, jsonData: $jsonData)';

  // @override
  // bool operator ==(Object o) {
  //   if (identical(this, o)) return true;
  
  //   return o is Node &&
  //     o.idNode == idNode &&
  //     o.fiWidgetType == fiWidgetType &&
  //     o.jsonData == jsonData;
  // }

  @override
  int get hashCode => idNode.hashCode ^ fiWidgetType.hashCode ^ jsonData.hashCode;



  @override
  List<String> memberNames() {
    return ["idNode", "fiWidgetType", "jsonData"];
  }

  @override
  String tableName() {
    return "node";
  }

  @override
  String createStatement() {
    return '''
      create table '''+tableName()+''' ( 
        idNode integer null, 
        fiWidgetType integer null,
        jsonData text null
      )
    ''';
  }  
}
