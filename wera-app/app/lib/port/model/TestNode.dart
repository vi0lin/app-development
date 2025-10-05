import 'dart:convert';

import 'package:app/port/utils/DBProvider.dart';

class Payment extends Serializable with DataClass<Payment>, DBSProvider<Payment> {
  int idPayment;

  Payment({this.idPayment}) : super(idPayment);

  @override
  String createStatement() {
    return '''
      create table TestNode ( 
        idTestNode integer null
      )
    ''';
  }

  // TestNode copyWith({
  //   int idTestNode,
  //   int fiTestNodeType,
  //   String jsonData,
  // }) {
  //   return TestNode(
  //     idTestNode: idTestNode ?? this.idTestNode,
  //     fiTestNodeType: fiTestNodeType ?? this.fiTestNodeType,
  //     jsonData: jsonData ?? this.jsonData,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'idTestNode': idPayment
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Payment(
      idPayment: map['idTestNode']
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) => Payment.fromMap(json.decode(source));

  @override
  String toString() => 'TestNode(idTestNode: $idPayment)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Payment &&
      o.idPayment == idPayment;
  }

  @override
  int get hashCode => idPayment.hashCode;

  /*
  @override
  Map<String, dynamic> toJson() => {
  '$idTestNode': this.idTestNode,
  '$fiTestNodeType': this.fiTestNodeType,
  '$jsonData': this.jsonData,
  };

  @override
  factory TestNode.fromJson(Map<String, dynamic> json) {
    return TestNode(
      idTestNode: json['idTestNode'],
      fiTestNodeType: json['fiTestNodeType'],
      jsonData: json['jsonData']!=null?json['jsonData']:"",
    );
  }*/

  @override
  List<String> memberNames() {
    return ["idPayment"];
  }

  @override
  String tableName() {
    return "Payment";
  }
}
