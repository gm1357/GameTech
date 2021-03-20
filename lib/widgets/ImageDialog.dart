import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  ImageDialog(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: 0.5,
          maxScale: 3.0,
        ),
      ),
    );
  }
}