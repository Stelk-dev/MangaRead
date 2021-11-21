import 'package:flutter/material.dart';
import 'package:mangaread/functions/widgetsMangaVolume.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'functions/getXData.dart';
import 'package:get/get.dart';
import 'functions/webScraping.dart';

// Pagina di lettura del capitolo

class ReadCap extends StatefulWidget {
  String nameManga = "";
  String name = "";
  int index = 0; // Indice del capitolo nei capitoli totali
  List capsTotal = []; // Capitoli totali

  ReadCap({this.nameManga, this.name, this.index, this.capsTotal});

  @override
  _ReadCapState createState() => _ReadCapState();
}

class _ReadCapState extends State<ReadCap> with SingleTickerProviderStateMixin {
  PageController pageController = new PageController();
  final functionManga = new FunctionManga();
  Future functionFuture;
  final controller = Get.put(DataX());

  String nameNext = "";
  bool endCap = false;

  awaitFutureFunction() async {
    return await initReading(widget.capsTotal[widget.index][1]);
  }

  @override
  void initState() {
    super.initState();
    functionFuture = awaitFutureFunction();

    if (widget.index > 0)
      setState(() => nameNext = widget.name.split(' ')[0] +
          " " +
          widget.capsTotal[widget.index - 1][0].split(' ')[widget
                  .capsTotal[widget.index - 1][0]
                  .split(' ')
                  .indexOf("Capitolo") +
              1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          endCap && widget.index >= 0
              ? FlatButton(
                  onPressed: () {
                    controller.updateLastManga(widget.nameManga, widget.index,
                        widget.capsTotal[widget.index][1]);

                    widget.index > 0
                        ? Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                                builder: (context) => ReadCap(
                                      name: nameNext,
                                      index: widget.index - 1,
                                      capsTotal: widget.capsTotal,
                                    )))
                        : Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Text(
                        widget.index > 0 ? '$nameNext' : "FINE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      widget.index > 0 ? Icon(Icons.navigate_next) : Container()
                    ],
                  ))
              : Container()
        ],
      ),
      body: SafeArea(
          child: GetBuilder<DataX>(
        builder: (_) => FutureBuilder(
            future: functionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return PhotoViewGallery.builder(
                    backgroundDecoration:
                        BoxDecoration(color: Colors.transparent),
                    itemCount: snapshot.data,
                    onPageChanged: (index) {
                      setState(() => endCap = (index + 1) == snapshot.data);
                    },
                    builder: (_, index) => functionManga.scanManga(
                        widget.capsTotal[widget.index][1] + "/${index + 1}",
                        index));
              else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
      )),
    );
  }
}
