import 'dart:math';
import 'package:flutter/material.dart';

class LazyLoader extends StatefulWidget {
  @override
  _LazyLoaderState createState() => _LazyLoaderState();
}

class _LazyLoaderState extends State<LazyLoader> {
  final _pairList = <dynamic>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _itemFetcher = _ItemFetcher();

  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
    _loadMore();
  }

  void _loadMore() {
    _isLoading = true;
    _itemFetcher.fetch().then((List<dynamic> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _pairList.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Need to display a loading tile if more items are coming
      itemCount: _hasMore ? _pairList.length + 1 : _pairList.length,
      itemBuilder: (BuildContext context, int index) {
        // Uncomment the following line to see in real time how ListView.builder works
        // print('ListView.builder is building index $index');
        if (index >= _pairList.length) {
          if (!_isLoading) {
            _loadMore();
          }
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 24,
              width: 24,
            ),
          );
        }
        return ListTile(
          leading: Text(index.toString(), style: _biggerFont),
          title: Text(_pairList[index].asPascalCase, style: _biggerFont),
        );
      },
    );
  }
}

class _ItemFetcher {
  final _count = 103;
  final _itemsPerPage = 5;
  int _currentPage = 0;

  // This async function simulates fetching results from Internet, etc.
  Future<List<dynamic>> fetch() async {
    final list = <dynamic>[];
    final n = min(_itemsPerPage, _count - _currentPage * _itemsPerPage);
    // Uncomment the following line to see in real time now items are loaded lazily.
    // print('Now on page $_currentPage');
    await Future.delayed(Duration(seconds: 1), () {
      for (int i = 0; i < n; i++) {
        list.add("Test");
      }
    });
    _currentPage++;
    return list;
  }
}