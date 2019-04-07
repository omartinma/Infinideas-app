import 'package:flutter/material.dart';
import 'package:infinidea/blocs/IdeasBloc.dart';
import 'package:infinidea/models/idea.dart';
import 'idea_item.dart';

class IdeasFeed extends StatefulWidget {
  IdeasFeed({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IdeasFeedState createState() => _IdeasFeedState();
}

class _IdeasFeedState extends State<IdeasFeed> {
  @override
  void initState() {
    bloc.fetchIdeas();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Idea>>(
          stream: bloc.ideasStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      title: Text('InfinIdea'),
                      backgroundColor: Colors.black,
                      expandedHeight: 200.0,
                    ),
                    SliverList (
                      delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return IdeaItem(
                            idea: snapshot.data[index],
                          );
                        }
                      )
                    )
                ]
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
