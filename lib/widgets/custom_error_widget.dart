import 'package:flutter/material.dart';

class CustomErrorWidget extends StatefulWidget {
  final String title;
  final IconData iconData;

  CustomErrorWidget({this.title, this.iconData});

  @override
  _CustomErrorWidgetState createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.iconData,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(widget.title),
        ],
      ),
    );
  }
}
