import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/comments_provider.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  Widget build(BuildContext context) {
    CommentsBloc bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (BuildContext context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading');
        }

        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (BuildContext context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Loading');
            }

            return buildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> comments) {
    final List<Comment> commentsList = item.kids.map((kidId) {
      return Comment(itemId: kidId, comments: comments, depth: 0);
    }).toList();

    final List<Widget> children = <Widget>[];
    children.add(buildTitle(item));
    children.addAll(commentsList);

    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
