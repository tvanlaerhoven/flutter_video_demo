import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:flutter_video_demo/src/MediaSection.dart';

class MediaList extends StatefulWidget {
  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  var mediaListData;

  initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final mediaListJson =
        await rootBundle.loadString('assets/media.exolist.json');
    this.setState(() => mediaListData = json.decode(mediaListJson));
  }

  buildMediaSection(sectionData) {
    return MediaSection(sectionData);
  }

  @override
  Widget build(BuildContext context) {
    // wait until list is loaded
    if (mediaListData == null) {
      return Container(
        color: Colors.black,
      );
    }

    return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            buildMediaSection(mediaListData[index]),
        itemCount: mediaListData.length);
  }
}
