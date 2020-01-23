import 'package:flutter/material.dart';
import 'package:flutter_video_demo/src/MediaEntry.dart';

class MediaSection extends StatelessWidget {
  const MediaSection(this.sectionData);

  final sectionData;

  buildElements() {
    if (!sectionData.containsKey('samples') ||
        sectionData['samples'].length == 0) {
      return ListTile(title: Text(sectionData['name']));
    }
    final entries = sectionData['samples'];
    return ExpansionTile(
      key: PageStorageKey(sectionData),
      title: Text(sectionData['name']),
      children: entries.map<Widget>((entry) => MediaEntry(entry)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildElements();
  }
}
