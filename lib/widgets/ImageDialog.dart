import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  ImageDialog(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
        maxScale: 3,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            )
          ),
        ),
      ),
    );
  }
}