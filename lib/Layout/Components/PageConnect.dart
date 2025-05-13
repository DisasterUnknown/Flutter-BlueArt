import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int index;
  const PageContent({required this.index});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(index: index, children: [
      Text('Index 0: Home'),
      Text('Index 1: Business'),
      Text('Index 2: Uni'),
    ]);
  }
}