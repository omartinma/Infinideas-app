import 'package:flutter/material.dart';
import 'package:infinideas/models/idea.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'styles.dart';
import 'themes.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'connectivity_check.dart';
import 'package:infinideas/blocs/favorite_bloc.dart';

class IdeaItem extends StatefulWidget {

  IdeaItem({Key key, this.idea, this.isDarkTheme}) : super(key: key);
  final Idea idea;
  final bool isDarkTheme;

  @override
  _IdeaItemState createState() => _IdeaItemState(this.idea, this.isDarkTheme);
}

class _IdeaItemState extends State<IdeaItem> {

  _IdeaItemState(this.idea, this.isDarkTheme);

  final Idea idea;
  final bool isDarkTheme;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    favoriteInitialState(idea);
  }

  Future <void> favoriteInitialState(Idea idea) async {
    bool ideaExists = await favoritesBloc.ideaAlreadyExists(idea);
    setState(() {
      isFavorite = ideaExists;
    });
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        _openWebView(context, idea, isDarkTheme);
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 18, top: 28, right: 28, bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Chip(
                          label: Text(idea.votes.toString() + ' UPVOTES'),
                          backgroundColor: getLabelBackgroundColor(idea.votes),
                          labelStyle: STYLE_TEXT_TAG),
                      Text(idea.title, style: STYLE_TITLES),
                      idea.description != ''
                          ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(idea.description,
                              maxLines: 3, overflow: TextOverflow.ellipsis))
                          : Container(),
                      SizedBox(height: 10)
                    ]),
              ),
              Row(children: <Widget>[
                IconButton(
                  icon: getIconForIdea(),
                  color: getMenuIconColor(isDarkTheme),
                  tooltip: 'Favorite',
                  alignment: Alignment.centerLeft,
                  onPressed: () {
                    toggleFavoriteIcon(idea);
                  },),
                Text(idea.source, style: getStyleMeta(isDarkTheme)),
                Text(' • ', style: getStyleMeta(isDarkTheme)),
                Text(timeago.format(new DateTime.fromMillisecondsSinceEpoch(idea.timestamp)), style: getStyleMeta(isDarkTheme)),
              ])
            ],
          )),
    );
  }

  Icon getIconForIdea() {
    if (isFavorite) {
      return Icon(Icons.favorite);
    }
    return Icon(Icons.favorite_border);
  }

  void toggleFavoriteIcon(Idea idea) {
    favoritesBloc.toggleIdea(idea);
    setState(() {
      this.isFavorite = !this.isFavorite;
    });
  }

  Future<void> _openWebView(BuildContext context, Idea idea, bool isDarkTheme) async {
    var connected = await isConnectionActivated(context);
    if(connected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return new WebviewScaffold(
              url: idea.url,
              appBar: new AppBar(
                title: new Text(idea.title),
                backgroundColor: getAppBarBackground(isDarkTheme),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share('Hey, I just discovered this cool idea '
                          'thanks to the Infinideas app (https://infinideas.learn.uno) '
                          '💡 ${idea.url}');
                    },
                  )
                ],
              ));
        }),
      );
    } else {
      displayAlertWhenNoConnection(context);
    }
  }
}


