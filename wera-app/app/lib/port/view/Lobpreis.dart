import 'dart:convert';
import 'package:app/port/utils/ApplicationCache.dart';
import 'package:app/port/app-hierarchy/StateWidget.dart';
import 'package:flutter/rendering.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import '../utils/Network.dart';
import '../model/Song.dart';
import '../utils/weraStyle.dart';
import 'package:flutter/material.dart';

enum EditMode {
  Text,
  Chords,
  User
}

enum Tabs {
  text,
  page2,
  page3,
}

class LobpreisModel {
  EditMode mode;
  
  TextEditingController titleController;
  String title = Songs.song!=null?Songs.song.title:"";
  TextEditingController lyricsController;
  String lyrics = Songs.song!=null?Songs.song.text:"";
  TextEditingController searchBoxController;
  Widget textareaWrapper;
  List<Song> searchResults = [];
  List<Widget> searchResultTiles = [];
  FocusNode songsuchefocusnode;
  Widget searchBox;

  bool movingRight = false;
  double movingRightPosition;
  double dx;

  Widget page;

  TextField textfield;
  Text text;
  SingleChildScrollView scsv;
  Padding textwrapper;
  
  LinkedScrollControllerGroup _controllers;
  ScrollController _textfield;
  ScrollController _scsv;
  ScrollController _text;
  double oldOffset = 0;

  Widget searchResultsOrContent;

  LobpreisModel();
//  update() { if(Songs.song != null) updateLyrics(Songs.song.text); if(Songs.song != null) updateTitle(Songs.song.title); }
  updateLyrics(String value) { Songs.song.text = value; this.lyrics = value; lyricsController.text = value; Songs.song.text = value; }
  updateTitle(String value) { Songs.song.title = value; this.title = value; titleController.text = value; Songs.song.title = value; }
  updateSong(Song song) {
    Songs.song = song;
    updateTitle(song.title);
    updateLyrics(song.text);
  }
  updateSearch(String value) { print(value); this.searchResults = ApplicationCache.songs.where( (i) => i.title.toLowerCase().contains(value.toLowerCase())  ).toList(); }
  updateSearchResults(List<Song> songs) { this.searchResults = songs; }
  /*song.then((Song s) => this.value = s.text)*/
}

class Lobpreis extends StatefulWidget {
  
  static LobpreisState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return (context.findAncestorWidgetOfExactType<_LobpreisData>()).data;
  }

  @override
  LobpreisState createState() => LobpreisState();
}

class LobpreisState extends State<Lobpreis> with WidgetsBindingObserver {

  AppLifecycleState _lastLifecycleState;

  LobpreisModel model;

  FocusNode _searchBoxFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    // Build the content depending on the state:
    return _buildLobpreisScreen(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  Widget _buildLobpreisScreen(BuildContext context) {
    if(this.model.page == null)
      this.model.page = page1(context);
    return Column(
      children: <Widget>[
        /* this.model.searchBox, */
        songsuche(context),
        this.model.searchResultsOrContent,
      ],
    );
  }

  @override
  void initState() {
    //super.initState();
    if(this.model == null) this.model = new LobpreisModel();
    if(this.model._controllers == null) {
      this.model._controllers = LinkedScrollControllerGroup();
      this.model._text = this.model._controllers.addAndGet();//new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);//this.model._controllers.addAndGet();
      this.model._textfield = this.model._controllers.addAndGet();//new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);//this.model._controllers.addAndGet();
       this.model._scsv = this.model._controllers.addAndGet();
      //this.model._controllers.addOffsetChangedListener(() {
        //this.model.oldOffset = this.model._controllers.offset;
      //});
      if(this.model.searchResultsOrContent == null)
        this.model.searchResultsOrContent = content(context);
    }
    
    //if(this.model.scsv == null) this.model.scsv = scsv();
    //if(this.model.textfield == null) this.model.textfield = textfield();
    //if(this.model.textwrapper == null) this.model.textwrapper = textwrapper();

    if(this.model.lyricsController == null)
      this.model.lyricsController = new TextEditingController();
    

    if(this.model.titleController == null)
      this.model.titleController = new TextEditingController();


    if(this.model.searchBoxController == null)
      this.model.searchBoxController = new TextEditingController();
    /* if(Songs.songs == null) {
      Songs.loadSongs().then( (t) {
        setState( () { Songs.songs = t; });
      });
      //Song.fetchSong(1).then( (Song t) {

      //setState( () { this.model.song = t; this.model.updateValue(t.text); });

      //});
    } */
    /* if(this.model.searchBox == null) {
      this.model.searchBox = songsuche();
    } */


    if(this.model.songsuchefocusnode == null) {
      this.model.songsuchefocusnode = new FocusNode();
      this.model.songsuchefocusnode.addListener(_onFocusChange);
    }

    if(!this._searchBoxFocus.hasListeners) {
      this._searchBoxFocus.addListener(_onFocusChange);
    }

    //if(this.model.movingRightPosition == null)
    //  this.model.movingRightPosition = MediaQuery.of(context).size.width;
  }
  void _onFocusChange(){
    setState( () {
      print(">>"+this.model.songsuchefocusnode.hasFocus.toString());
      print(">>"+_searchBoxFocus.hasFocus.toString());
      if(this._searchBoxFocus.hasFocus)
        this.model.searchResultsOrContent = searchResults(context);
      else
        this.model.searchResultsOrContent = content(context);
    });
  }

  Tabs t = Tabs.text;
  Widget buttons(context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: FlatButton(
            color: t == Tabs.text ? weralightBlack : weraYellow,
            onPressed: () {
              setState(() {
                //double offset = _scroller1.positions.length > 0 && _scroller1.position.extentAfter == 0.0 ? 0.0 : _scroller1.offset;
                //this.model.updateMode(EditMode.Text);
                //Future.delayed(const Duration(milliseconds: 3000), () {
                //setState(() {});
                //});
                //_scroller2..jumpTo(offset);
                this.model.page = page1(context);
                t = Tabs.text;
                this.model.searchResultsOrContent = content(context);
              });
              
            },
            child: Icon(Icons.insert_comment, color: t == Tabs.text ? weraWhite : weraBlack),
          ),
        ),
        Text(" "),
        Expanded(
          flex: 1,
          child: FlatButton(
            color: t == Tabs.page2 || t == Tabs.page3 ? weralightBlack : weraYellow,
            onPressed: () {
              setState(() {
                //double offset = _scroller1.positions.length > 0 && _scroller1.position.extentAfter == 0.0 ? 0.0 : _scroller1.offset;
                //this.model.updateMode(EditMode.Text);
                //Future.delayed(const Duration(milliseconds: 3000), () {
                //setState(() {});
                //});
                //_scroller2..jumpTo(offset);
                if(t == Tabs.page2) {
                  this.model.page = page3();
                  t = Tabs.page3;
                }
                else {
                  this.model.page = page2();
                  t = Tabs.page2;
                }
                
                this.model.searchResultsOrContent = content(context);
              });
              
            },
            child: Icon(Icons.edit, color: t == Tabs.page2 || t == Tabs.page3 ? weraWhite : weraBlack),
          ),
        ),
        Text(" "),
        Expanded(
          flex: 1,
          child: FlatButton(
            
            color: t != Tabs.page2 && t != Tabs.page3 ? weraLightbeige : weraYellow,
            //textColor: Colors.white,
            //disabledColor: Colors.grey,
            //disabledTextColor: Colors.black,
            //padding: EdgeInsets.all(8.0),
            //splashColor: Colors.blueAccent,
            onPressed: () {
              if(t != Tabs.page2 && t != Tabs.page3)
                return null;
              else {
                setState(() {
                  //double offset = _scroller2.positions.length > 0 && _scroller2.position.extentAfter == 0.0 ? 0.0 : _scroller2.offset;
                  //this.model.updateMode(EditMode.Chords);
                  //FocusScope.of(context).requestFocus(new FocusNode());
                  //Future.delayed(const Duration(milliseconds: 3000), () {
                  //  setState(() {});
                  //});
                  //_scroller1.jumpTo(offset);

                  this.model.updateLyrics(model.lyricsController.text);
                  API1.requestOutdated("PATCH", "Song/"+Songs.song.id.toString(), Songs.song.toJson());
                  SongProvider.instance.updateSong(Songs.song);
                  this.model.page = page1(context);
                  t = Tabs.text;

                });
              }
            },
            child: Icon(Icons.save, color: t != Tabs.page2 && t != Tabs.page3 ? weraVerylightbeige : weraBlack,),
          ),
        ),
        Text(" "),
        Expanded(
          flex: 1,
          child: FlatButton(
            color: weraYellow,
            //textColor: Colors.white,
            //disabledColor: Colors.grey,
            //disabledTextColor: Colors.black,
            //padding: EdgeInsets.all(8.0),
            //splashColor: Colors.blueAccent,
            onPressed: () {
            },
          child: Icon(Icons.arrow_upward),
          ),
        ),
        Text(" "),
        Expanded(
          flex: 1,
          child: FlatButton(
            color: weraYellow,
            //textColor: Colors.white,
            //disabledColor: Colors.grey,
            //disabledTextColor: Colors.black,
            //padding: EdgeInsets.all(8.0),
            //splashColor: Colors.blueAccent,
            onPressed: () {
              },
            child: Icon(Icons.arrow_downward),
            ),
        ),
        Text(" "),
        Expanded(
          flex: 1,
          child: FlatButton(
            color: weraYellow,
            //textColor: Colors.white,
            //disabledColor: Colors.grey,
            //disabledTextColor: Colors.black,
            //padding: EdgeInsets.all(8.0),
            //splashColor: Colors.blueAccent,
            onPressed: () {
            },
          child: Icon(Icons.format_size),
          ),
        ),
        Text(" "),
      ],
    );
  }

  Widget page1(context) {
    return SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(0),
        child: song()
      )
    );
  }

  Widget page2() {
    TextField title = TextField(
      style: textStyleTitle,
      textAlign: TextAlign.center,
      controller: model.titleController,
      maxLines: 1,
      decoration: new InputDecoration(hintText: "Titel.", contentPadding: EdgeInsets.all(0) ),
      onChanged: (text) {
        this.model.title = text;
        Songs.song.title = text;
      },
    );
    TextField lyrics = TextField(
      style: textStyleLyrics,
      textAlign: TextAlign.center,
      controller: model.lyricsController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: new InputDecoration(hintText: "Lyrics.", contentPadding: EdgeInsets.all(0)),
      onChanged: (text) {
        this.model.lyrics = text;
        Songs.song.text = text;
      },
    );
    //      scrollController: this.model._textfield,
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 3),
          child: Column(
            children: <Widget>[
              title,
              lyrics,
            ]
          )
        )
    );
  }

  Widget song() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          title(),
          lyrics(),
    ]);
  }

  Widget title() {
    print("##>"+this.model.title);
    return Padding(padding: EdgeInsets.only(top:13, bottom: 12), child: Text(this.model.title, textAlign: TextAlign.center, style: textStyleTitle));
  }

  Widget lyrics() {
    print("##>"+this.model.lyrics);
    return Text(this.model.lyrics, textAlign: TextAlign.center, style: textStyleLyrics);
  }



  Widget scsv() {
    Column stack = Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              new Image.asset(
                'img/aim.png',
              ),
              Center(child: song()),
              Row(children: <Widget>[
                Row(children: <Widget>[
                  Column(
                    children: <Widget>[
                    Text("G"), Text("F"), Text("C")
                  ],)
                ],),
                Row(children: <Widget>[
                  Column(children: <Widget>[
                    Text("G"), Text("F"), Text("C")
                  ],)
                ],)
              ],),
            ],
          )
        ],
    );
    return stack;
  }

  Widget page3() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            scsv(),
          ],
        ),
      )
    );
  }

  Widget piano() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 0,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(" ")
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  color: weraBlack,
                  textColor: weraWhite,
                  onPressed: () {
                  },
                  child: Text("C#"),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  color: weraBlack,
                  textColor: weraWhite,
                  onPressed: () {
                  },
                  child: Text("D#"),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(" ")
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  color: weraBlack,
                  textColor: weraWhite,
                  onPressed: () {
                  },
                  child: Text("F#"),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  color: weraBlack,
                  textColor: weraWhite,
                  onPressed: () {
                  },
                  child: Text("G#"),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  color: weraBlack,
                  textColor: weraWhite,
                  onPressed: () {
                  },
                  child: Text("A#"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(" ")
              ),
            ],
          ),
        ),
        Expanded(
          flex: 0,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: weraWhite,
                  onPressed: () {
                  },
                  child: Text("C"),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: weraWhite,
                  onPressed: () {
                  },
                  child: Text("D"),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: weraWhite,
                  onPressed: () {
                  },
                  child: Text("E"),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: weraWhite,
                  onPressed: () {
                  },
                  child: Text("F"),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: weraWhite,
                  onPressed: () {
                  },
                  child: Text("G"),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: weraWhite,
                  onPressed: () {
                  },
                  child: Text("A"),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: weraWhite,
                  onPressed: () {
                  },
                  child: Text("H"),
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }

  Padding textwrapper2() {
    Padding p = Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: this.model.textfield,
          ),
          Expanded(
            flex: 0,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(" ")
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    color: weraBlack,
                    textColor: weraWhite,
                    onPressed: () {
                    },
                    child: Text("C#"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    color: weraBlack,
                    textColor: weraWhite,
                    onPressed: () {
                    },
                    child: Text("D#"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child:Text(" ")
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    color: weraBlack,
                    textColor: weraWhite,
                    onPressed: () {
                    },
                    child: Text("F#"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    color: weraBlack,
                    textColor: weraWhite,
                    onPressed: () {
                    },
                    child: Text("G#"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    color: weraBlack,
                    textColor: weraWhite,
                    onPressed: () {
                    },
                    child: Text("A#"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(" ")
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: weraWhite,
                    onPressed: () {
                    },
                    child: Text("C"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: weraWhite,
                    onPressed: () {
                    },
                    child: Text("D"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: weraWhite,
                    onPressed: () {
                    },
                    child: Text("E"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: weraWhite,
                    onPressed: () {
                    },
                    child: Text("F"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: weraWhite,
                    onPressed: () {
                    },
                    child: Text("G"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: weraWhite,
                    onPressed: () {
                    },
                    child: Text("A"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: weraWhite,
                    onPressed: () {
                    },
                    child: Text("H"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return p;
  }

  Widget content(context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Songs.song == null ?
          Expanded(child: Text("Lobpreis aussuchen.")) :
          Expanded(child: this.model.page),
          (isAdmin(context) && !impersonateUser) ? buttons(context) : null
        ]..removeWhere((widget) => widget == null)
      )
    );
  }
  
  Widget searchResults(context) {
    return Expanded(
      child: GestureDetector(
        onTap: () { setState(() { if(_searchBoxFocus.hasFocus) FocusScope.of(context).requestFocus(new FocusNode()); }); },
        child: _myGridView(context)
      )
    );
  }

  Widget songsuche(context) {
    return Padding(
      child: TextField(
        focusNode: _searchBoxFocus,
        style: textStyleLightSmall,
        controller: this.model.searchBoxController,
        keyboardType: TextInputType.text,
        maxLines: null,
        decoration: new InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: weraVerylightgray)), hintText: "Songsuche", contentPadding: const EdgeInsets.only(top: 0,bottom:0,left: 7, right: 7)),
        onChanged: (txt) { setState(() { this.model.updateSearch(txt); }); },
        onTap: () { setState(() { this.model.updateSearch(this.model.searchBoxController.text); /* this.model.lyricsController.selection = TextSelection(baseOffset: 0, extentOffset: this.model.lyricsController.text.length); */ }); },
        onEditingComplete: () {
          setState(() {
            FocusScope.of(context).requestFocus(new FocusNode());
          });
        },
      ), padding: EdgeInsets.all(7),
    );
  }

  Widget _myGridView(context) {
    this.model.searchResultTiles = [];
    for(var i = 0; i < this.model.searchResults.length; i++) {
      this.model.searchResultTiles.add(
        FlatButton(
          onPressed: () {
            Song selected = this.model.searchResults.elementAt(i);
            setState( () {
              this.model.updateSong(selected);
              this.model.page = page1(context);
              this.model.searchResultsOrContent = content(context);
              FocusScope.of(context).requestFocus(new FocusNode());

              API1.requestOutdated("GET", "Song/"+selected.id.toString()).then((response) {
                Map<String, dynamic> j = jsonDecode(response.body);
                Song dbSong = Song.fromJson(j);
                if (dbSong.modified.isAfter(selected.modified)) {
                  int i = ApplicationCache.songs.indexOf(selected);
                  setState(() {
                    Songs.song = dbSong;
                    ApplicationCache.songs.removeAt(i);
                    ApplicationCache.songs.insert(i,dbSong);
                    SongProvider.instance.updateSong(dbSong);
                    this.model.updateSong(dbSong);
                    this.model.updateLyrics(dbSong.text);
                    this.model.updateTitle(dbSong.title);
                    this.model.updateSearch(this.model.searchBoxController.text);
                    this.model.page = page1(context);
                    this.model.searchResultsOrContent = content(context);
                  });
                }   
              });
            });
          },
          padding: new EdgeInsets.all(7),
          color: weraWhite,
          focusColor: weraLightgray,
          highlightColor: weraYellow,
          child: Text(
            this.model.searchResults.elementAt(i).title,
            style: textStyleGraysmall
          ),
        )
      );
    }
    return GridView.count(
      childAspectRatio: 2.8,
      crossAxisCount: 2,
      padding: new EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
      children: this.model.searchResultTiles,
    );
  }

}

class _LobpreisData extends InheritedWidget {
  final LobpreisState data;
  _LobpreisData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_LobpreisData old) => true;
}