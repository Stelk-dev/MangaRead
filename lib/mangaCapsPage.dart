import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mangaread/functions/widgetsMangaVolume.dart';
import 'functions/getXData.dart';
import 'functions/webScraping.dart';

// Pagina delle ricerche dei manga

class CapsPage extends StatelessWidget {
  final controller = Get.put(DataX());
  final FunctionManga functionManga = new FunctionManga();

  Future<void> refreshPage(context) async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => CapsPage(),
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.go,
            onEditingComplete: () {
              if (controller.nameManga.value.length != 0) refreshPage(context);
            },
            initialValue: controller.nameManga.value,
            onChanged: (value) => controller.updateManga(value),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (controller.nameManga.value.length != 0)
                      refreshPage(context);
                  }),
            )
          ],
        ),
        body: FutureBuilder(
            future: getManga(controller.nameManga.value),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (snapshot.data.isEmpty)
                return Center(
                  child: Text('No Manga found'),
                );
              else
                return RefreshIndicator(
                    onRefresh: () => refreshPage(context),
                    child: functionManga.mangaSearch(snapshot, context));
            }));
  }
}
