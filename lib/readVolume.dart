import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'functions/getXData.dart';
import 'functions/widgetsMangaVolume.dart';
import 'package:mangaread/readingPage.dart';
import 'functions/webScraping.dart';

// Pagina del volume selezionato

class VolumePage extends StatelessWidget {
  final controller = Get.put(DataX());
  final FunctionManga functionManga = FunctionManga(); // Funzioni widget

  String urlManga = "";
  String nameManga = "";
  String imgManga = "";
  String genresManga = "";
  var saved = Icons.bookmark_border.obs;

  VolumePage({this.urlManga, this.nameManga, this.imgManga, this.genresManga});

  // Funzione per andare al volume quando si clicca il pulsante
  void goToCap(String name, int index, List capsTotal, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ReadCap(
              nameManga: nameManga,
              name: name.split(' ')[name.split(' ').indexOf("Capitolo")] +
                  " " +
                  name.split(' ')[name.split(' ').indexOf("Capitolo") + 1],
              index: index,
              capsTotal: capsTotal,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataX>(
      initState: (_) {
        // Settaggio dei manga iniziati
        controller.setMangaSaved();

        if (controller.searchLastManga(nameManga) != null)
          controller.resume_start = "Continua".obs;
        else
          controller.resume_start = "Inizia".obs;

        // Settaggio dei manga salvati
        if (controller.mangaIsSaved([
          nameManga,
          [urlManga, imgManga],
          genresManga
        ])) saved = Icons.bookmark.obs;

        controller.update();
      },
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              nameManga,
              overflow: TextOverflow.visible,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(
                    saved.value,
                    size: 28,
                  ),
                  onPressed: () {
                    controller.savedManga([
                      nameManga,
                      [urlManga, imgManga],
                      genresManga
                    ], saved.value == Icons.bookmark_border);
                    // Se devo salvarlo sarà true se no false

                    saved.value = saved.value == Icons.bookmark_border
                        ? Icons.bookmark
                        : Icons.bookmark_border;
                    controller.update();
                  }),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
          future: getCapsManga(urlManga),
          builder: (_, snapshot) {
            if (snapshot.hasData)
              return Scrollbar(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(5),
                  itemCount: snapshot.data[1].length + 1,
                  itemBuilder: (_, index) {
                    index = snapshot.data[1].length - index - 1;
                    if (index == snapshot.data[1].length - 1)
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Card(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              functionManga.cardMangaDescription(
                                  snapshot, imgManga, genresManga, context),
                              functionManga.containerWithTrama(snapshot),
                              Center(
                                // ignore: deprecated_member_use
                                child: FlatButton(
                                  onPressed: () {
                                    final mangaSaved =
                                        controller.searchLastManga(nameManga);

                                    if (controller.resume_start.value ==
                                        "Inizia") {
                                      final name = snapshot.data[1][index][0];
                                      controller.updateLastManga(nameManga,
                                          index, snapshot.data[1][index][1]);

                                      goToCap(name, index, snapshot.data[1],
                                          context);
                                    } else {
                                      final name =
                                          snapshot.data[1][mangaSaved[1][0]][0];
                                      goToCap(name, mangaSaved[1][0],
                                          snapshot.data[1], context);
                                    }
                                  },
                                  child: Text(
                                    controller.resume_start.value,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  color:
                                      controller.resume_start.value == "Inizia"
                                          ? Colors.green
                                          : Colors.lightBlue,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    else
                      return functionManga.capsSingle(
                          nameManga,
                          snapshot.data[1][index + 1][0],
                          index + 1,
                          snapshot.data[1],
                          context);
                  },
                ),
              );
            else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
