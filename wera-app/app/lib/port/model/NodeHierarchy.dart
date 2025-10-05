import 'dart:convert';

class NodeHierarchy {
  int fiParentNode;
  int fiNode;
  int sort;
  NodeHierarchy({
    this.fiParentNode,
    this.fiNode,
    this.sort,
  });

  NodeHierarchy copyWith({
    int fiParentNode,
    int fiNode,
    int sort,
  }) {
    return NodeHierarchy(
      fiParentNode: fiParentNode ?? this.fiParentNode,
      fiNode: fiNode ?? this.fiNode,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fiParentNode': fiParentNode,
      'fiNode': fiNode,
      'sort': sort,
    };
  }

  factory NodeHierarchy.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return NodeHierarchy(
      fiParentNode: map['fiParentNode'],
      fiNode: map['fiNode'],
      sort: map['sort'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NodeHierarchy.fromJson(String source) => NodeHierarchy.fromMap(json.decode(source));

  @override
  String toString() => 'NodeHierarchy(fiParentNode: $fiParentNode, fiNode: $fiNode, sort: $sort)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is NodeHierarchy &&
      o.fiParentNode == fiParentNode &&
      o.fiNode == fiNode &&
      o.sort == sort;
  }

  @override
  int get hashCode => fiParentNode.hashCode ^ fiNode.hashCode ^ sort.hashCode;
}
