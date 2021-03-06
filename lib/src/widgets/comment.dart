import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../widgets/loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> comments;
  final int depth;

  Comment({this.itemId, this.comments, this.depth});

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: comments[itemId],
      builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        ItemModel item = snapshot.data;

        final List<Widget> children = [
          ListTile(
            title: buildText(item),
            subtitle: item.by == '' ? Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth + 1) * 16.0
            ),
          ),
          Divider()
        ];

        item.kids.forEach((kidId) {
          children.add(Comment(
            itemId: kidId,
            comments: comments,
            depth: depth + 1,
          ));
        });

        return Column(children: children);
      },
    );
  }

  Widget buildText(ItemModel item) {
    String text = item.text
      .replaceAll('&#x2F;', '/')
      .replaceAll('&#x27;', "'")
      .replaceAll('<p>', '\n\n')
      .replaceAll('<p>', '')
      .replaceAll('&gt;', '>')
      .replaceAll('&lt;', '<')
      .replaceAll('&quot;', "'");

    return Text(text);
  }
}
