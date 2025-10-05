import 'dart:convert';

class NodeUserPermission {
  int fiNode;
  int recursion;
  NodeUserPermission({
    this.fiNode,
    this.recursion,
  });

  NodeUserPermission copyWith({
    int fiNode,
    int recursion,
  }) {
    return NodeUserPermission(
      fiNode: fiNode ?? this.fiNode,
      recursion: recursion ?? this.recursion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fiNode': fiNode,
      'recursion': recursion,
    };
  }

  factory NodeUserPermission.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return NodeUserPermission(
      fiNode: map['fiNode'],
      recursion: map['recursion'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NodeUserPermission.fromJson(String source) => NodeUserPermission.fromMap(json.decode(source));

  @override
  String toString() => 'NodeUserPermission(fiNode: $fiNode, recursion: $recursion)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is NodeUserPermission &&
      o.fiNode == fiNode &&
      o.recursion == recursion;
  }

  @override
  int get hashCode => fiNode.hashCode ^ recursion.hashCode;
}
