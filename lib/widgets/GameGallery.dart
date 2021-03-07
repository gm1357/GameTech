import 'package:flutter/material.dart';
import 'package:gametech/models/gameDetail.dart';
import 'package:gametech/widgets/ImageDialog.dart';

class GameGallery extends StatelessWidget {
  final Future<GameDetail> futureGameDetails;

  GameGallery(this.futureGameDetails);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureGameDetails,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState != ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: snapshot.data.images
                  .map((imagesUrl) => GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) => ImageDialog(imagesUrl.medium));
                        },
                        child: Image.network(
                          imagesUrl.large,
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList()
                  .cast<Widget>(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}