import 'package:assignment/Lists/productsList.dart';
import 'package:flutter/material.dart';

class ViewProductDetailsPage extends StatefulWidget {
  final Item? ProductID;
  const ViewProductDetailsPage({super.key, required this.ProductID});

  @override
  State<ViewProductDetailsPage> createState() => _ViewProductDetailsPageState();
}

class _ViewProductDetailsPageState extends State<ViewProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}