import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoData extends StatelessWidget {
  final String message;

  const NoData({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/nodata.svg",
            height: 100.0,
            width: 100.0,
            color: Theme.of(context).iconTheme.color, // Adapts to the theme color
          ),
          SizedBox(height: 16.0),
          Text(
            message,
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).textTheme.bodyLarge?.color, // Adapts to the theme color
            ),
          ),
        ],
      ),
    );
  }
}
