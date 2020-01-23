import 'package:flutter/material.dart';

class MediaEntry extends StatelessWidget {
  const MediaEntry(this.entryData);

  final entryData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/player', arguments: entryData);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: ListTile(title: Text(entryData['name'])),
      ),
    );
  }
}
