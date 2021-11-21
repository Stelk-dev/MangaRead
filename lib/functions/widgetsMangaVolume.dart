import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangaread/functions/getXData.dart';
import 'package:mangaread/readingPage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../readVolume.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'webScraping.dart';

class FunctionManga {
  // Widget dei manga nella ricerca
  Widget mangaSearch(AsyncSnapshot snapshot, BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  // Go to volume
                  onTap: () =>
                      Navigator.of(context).push(CupertinoPageRoute<void>(
                    builder: (context) {
                      return CupertinoPageScaffold(
                          child: VolumePage(
                        nameManga: snapshot.data[index][0],
                        imgManga: snapshot.data[index][1],
                        urlManga: snapshot.data[index][2],
                        genresManga: snapshot.data[index][3][0],
                      ));
                    },
                  )),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2)),
                    // height: 210,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Container(
                            width: 130,
                            height: 190,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data[index][1],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index][0],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Generi:\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: snapshot.data[index][3][0]
                                            .toString(),
                                      )
                                    ], style: TextStyle(fontSize: 12))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Trama:\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: snapshot.data[index][3][1]
                                            .toString(),
                                      )
                                    ], style: TextStyle(fontSize: 12)))
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              )),
    );
  }

  // Description manga
  Widget cardMangaDescription(AsyncSnapshot<dynamic> snapshot, String imgManga,
      String genresManga, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            width: 130,
            height: 190,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: CachedNetworkImage(
              imageUrl: imgManga,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Generi:\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: genresManga.toString(),
                      )
                    ], style: TextStyle(fontSize: 13))),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Uscita:\n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: snapshot.data[0][2].toString())
                    ], style: TextStyle(fontSize: 14))),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                        text: TextSpan(
                            children: [
                          TextSpan(
                              text: 'Autore:\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: snapshot.data[0][0].toString(),
                          ),
                        ],
                            style: TextStyle(
                              fontSize: 13,
                            ))),
                    SizedBox(
                      height: 7,
                    ),
                    RichText(
                        text: TextSpan(
                            children: [
                          TextSpan(
                              text: 'Artista:\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: snapshot.data[0][1].toString(),
                          )
                        ],
                            style: TextStyle(
                              fontSize: 13,
                            )))
                  ],
                ),
              ),
            ))
      ],
    );
  }

  // Trama manga
  Widget containerWithTrama(AsyncSnapshot<dynamic> snapshot) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              "Trama:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              snapshot.data[0][3],
              style: TextStyle(fontSize: 12),
            )
          ],
        ));
  }

  // Manga in tendenza
  Widget mangaUps(String url, BuildContext context) {
    return FutureBuilder(
        future: getManga(url),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                // Go to volume
                onTap: () =>
                    Navigator.of(context).push(CupertinoPageRoute<void>(
                  builder: (context) {
                    return CupertinoPageScaffold(
                        child: VolumePage(
                      nameManga: snapshot.data[0][0],
                      imgManga: snapshot.data[0][1],
                      urlManga: snapshot.data[0][2],
                      genresManga: snapshot.data[0][3][0],
                    ));
                  },
                )),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Container(
                          width: 130,
                          height: 190,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data[0][1],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[0][0],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Generi:\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: snapshot.data[0][3][0].toString(),
                                    )
                                  ], style: TextStyle(fontSize: 12))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Trama:\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: snapshot.data[0][3][1].toString(),
                                    )
                                  ], style: TextStyle(fontSize: 12)))
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          else
            return Center(
              child: Container(
                  height: 210,
                  child: Center(child: CircularProgressIndicator())),
            );
        });
  }

  // Caps manga
  Widget capsSingle(String nameManga, String name, int i, List capsTotal,
      BuildContext context) {
    final controller = Get.put(DataX());
    final mangaSaved = controller.searchLastManga(nameManga);

    return GestureDetector(
      onTap: () {
        // Aggiorno i manga iniziati
        controller.updateLastManga(nameManga, i, capsTotal[i][1]);
        print(capsTotal);

        // Vai al manga
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ReadCap(
                  name: name.split(' ')[name.split(' ').indexOf("Capitolo")] +
                      " " +
                      name.split(' ')[name.split(' ').indexOf("Capitolo") + 1],
                  index: i,
                  capsTotal: capsTotal,
                )));
      },
      child: Card(
        color: mangaSaved == null
            ? Color.fromRGBO(33, 33, 33, 1)
            : i == mangaSaved[1][0]
                ? Colors.lightBlue
                : Color.fromRGBO(33, 33, 33, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$name",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Scna del manga
  PhotoViewGalleryPageOptions scanManga(String url, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: FutureBuilder(
          future: getImgFromLink(url),
          builder: (_, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.hasData)
              return PhotoView(
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 2,
                initialScale: PhotoViewComputedScale.contained,
                basePosition: Alignment.center,
                imageProvider: NetworkImage(snapshot.data.length == 1
                    ? snapshot.data[0]["attributes"]["src"]
                    : snapshot.data[index]["attributes"]["src"]),
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes,
                    ),
                  ),
                ),
              );
            else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }

  Widget cardImgMangaSvd(String name, String url, String img,
      String dataGenders, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (context) {
          return CupertinoPageScaffold(
              child: VolumePage(
            nameManga: name,
            imgManga: img,
            urlManga: url,
            genresManga: dataGenders,
          ));
        },
      )),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            boxShadow: [BoxShadow(blurRadius: 2)]),
        child: CachedNetworkImage(
          imageUrl: img,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
