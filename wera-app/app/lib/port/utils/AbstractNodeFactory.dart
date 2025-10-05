import 'dart:core';

import 'package:app/port/model/Node.dart';
import 'package:app/port/model/WidgetType.dart';
import 'package:app/port/utils/Network.dart';
import 'package:app/port/utils/config.dart';

abstract class IAbstractNodeFactory {
  List<Node> findNodesOfType(WidgetType type);
  Node findNode(int i);
  List<Node> findChildrenOf(int i);
  List<Node> updateNode(Node node);
}

class DBFactory extends IAbstractNodeFactory {
  @override
  List<Node> findNodesOfType(WidgetType type) { API1.requestSSL(REST.GET, Endpoint.Nodes); }
  @override
  Node findNode(int i) { return null; }
  @override
  List<Node> findChildrenOf(int i) { return null; }
  @override
  List<Node> updateNode(Node node) { return null; }
}

class CloudDBFactory extends IAbstractNodeFactory {
  @override
  List<Node> findNodesOfType(WidgetType type) { return null; }
  @override
  Node findNode(int i) { return null; }
  @override
  List<Node> findChildrenOf(int i) { return null; }
  @override
  List<Node> updateNode(Node node) { return null; }
}

class NodeFactory extends IAbstractNodeFactory {

  DBFactory dbFactory = new DBFactory();
  CloudDBFactory cloudDbFactory = new CloudDBFactory();

  @override
  List<Node> findNodesOfType(WidgetType type) {
      List<Node> result = dbFactory.findNodesOfType(type);
      if(result.isNotEmpty)
        return result;
      return cloudDbFactory.findNodesOfType(type);
  }
  @override
  Node findNode(int i) { return null; }
  @override
  List<Node> findChildrenOf(int i) { return null; }
  @override
  List<Node> updateNode(Node node) { return null; }
}