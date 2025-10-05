import 'dart:math';
import 'dart:ui';

import 'package:app/port/model/Article.dart';
import 'package:app/port/model/Song.dart';
import 'package:app/port/utils/Functions.dart';
import 'package:app/port/utils/weraStyle.dart';
import 'package:flutter/material.dart';

class MyArticleList extends StatefulWidget {

  const MyArticleList({ Key key }) : super(key: key);

  @override
  _MyArticleListState createState() => _MyArticleListState();
}

class MyArticleListModel {
  final _pairList = <Widget>[];
}

class _MyArticleListState extends State<MyArticleList> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  MyArticleListModel model;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _itemFetcher = _ItemFetcher();

  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
    if(this.model == null) {
      this.model = new MyArticleListModel();
    }
    _loadMore();
  }

  void _loadMore() {
    _isLoading = true;
    _itemFetcher.fetch().then((List<Widget> fetchedList) {
      print(fetchedList);
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          print("putting into _pairList.");
          _isLoading = false;
          this.model._pairList.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      // Need to display a loading tile if more items are coming
      itemCount: _hasMore ? this.model._pairList.length + 1 : this.model._pairList.length,
      itemBuilder: (BuildContext context, int index) {
        // Uncomment the following line to see in real time how ListView.builder works
        print('ListView.builder is building index $index');
        if (index >= this.model._pairList.length-10) {
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
        //return Text("Test");
        return this.model._pairList[index];
        /*ListTile(
          leading: Text(index.toString(), style: _biggerFont),
          title: Text(_pairList[index], style: _biggerFont),
        );*/
      },
    );
  }
}

class _ItemFetcher {

  Widget item() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('img/abstractBackgrounds/'+Random().nextInt(9).toString()+'.jpg')
                ),
              ),
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                      child: Column(
                        children: [
                          Text("Besonderer Gottesdienst", style: textStyleTextWhiteBig),
                          Text("Atemberaubende Atmosphäre in der Königs Pilsener Arena. Ein Besonderer Gottesdienst, der Eindruck hinterlässt und das Feuer, das nie erlischt.", style: textStyleTextBlack),
                          FittedBox(
                            child: Row(
                              children: [
                                  Icon(Icons.share, color:weraWhite, size: 20),
                                  Icon(Icons.thumb_up, color: weraWhite, size: 20)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ),
        SizedBox(height: 10),
      ]
    );
  }

  final _count = 103;
  final _itemsPerPage = 10;
  int _currentPage = 0;

  // This async function simulates fetching results from Internet, etc.
  Future<List<Widget>> fetch() async {
    final list = <Widget>[];
    final n = min(_itemsPerPage, _count - _currentPage * _itemsPerPage);
    // Uncomment the following line to see in real time now items are loaded lazily.
    // print('Now on page $_currentPage');
    await Future.delayed(Duration(seconds: 1), () {
      for (int i = 0; i < n; i++) {
        list.add(item());
      }
    });
    _currentPage++;
    return list;
  }
}