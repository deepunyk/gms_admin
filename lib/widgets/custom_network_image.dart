import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetWorkImage extends StatelessWidget {
  final photo;
  final assetLink;

  CustomNetWorkImage(this.photo,
      {this.assetLink = "assets/images/profile.png"});

  @override
  Widget build(BuildContext context) {
    return photo == null || photo == "no photo" || photo == ''
        ? Image.asset(
            assetLink,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : FadeInImage(
            image: CachedNetworkImageProvider(
              "$photo",
            ),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: double.infinity,
            placeholder: AssetImage(assetLink),
          );
  }
}
