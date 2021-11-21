import 'package:web_scraper/web_scraper.dart';

Future<List> getManga(String name) async {
  final webScraper = WebScraper('https://www.mangaworld.in');
  final endpoint = "/archive?keyword=$name";
  List values = [];

  if (await webScraper.loadWebPage(endpoint)) {
    print("(getManga) Load... ");

    final mangaImg = webScraper.getElement(
        "div.container > div.row > div.col-12 > div.comics-grid > div.entry > a.thumb > img",
        ['src', 'alt']);

    final mangaTest = webScraper.getElement("body", ['src', 'alt']);

    final mangaLink = webScraper.getElement(
        "div.container > div.row > div.col-12 > div.comics-grid > div.entry > a.thumb",
        ['href']);

    final mangaContent = webScraper.getElement(
        "div.container > div.row > div.col-12 > div.comics-grid > div.entry > div.content",
        []);

    for (int i = 0; i < mangaImg.length; i++) {
      String generi = mangaContent[i]["title"];

      values.add([
        mangaImg[i]["attributes"]["alt"],
        mangaImg[i]["attributes"]["src"],
        mangaLink[i]["attributes"]["href"],
        [
          generi.substring(
              generi.indexOf("Generi") + 8, generi.indexOf("Trama")),
          generi.substring(
              generi.indexOf("Trama") + 8, generi.indexOf("Ultima"))
        ]
      ]);
    }
    return values;
  } else {
    print("Error");
    return null;
  }
}

Future<void> getCapsManga(String url) async {
  final webScraper = WebScraper('https://www.mangaworld.io');
  final endpoint = "$url".replaceAll("https://www.mangaworld.io", "");
  List values = [];

  if (await webScraper.loadWebPage(endpoint)) {
    print("(getCapsManga) Load...");

    final mangaDescription = webScraper.getElement(
        "div.container > div.row > div.col-sm-12 > div.single-comic > div.bg-white > div.has-shadow > div.info > div.meta-data > div.col-12",
        []); // Descrizione div

    final mangaTrama = webScraper.getElement(
        "div.container > div.row > div.col-sm-12 > div.single-comic > div.bg-white > div.has-shadow",
        []); // Trama div

    List description = [];
    mangaDescription.forEach((element) {
      if (element["title"].split(' ')[0] == "Autore:" ||
          element["title"].split(' ')[0] == "Autori:")
        description.add(
            element["title"].substring(8, element["title"].length)); // Autore
      else if (element["title"].split(' ')[0] == "Artista:" ||
          element["title"].split(' ')[0] == "Artisti:")
        description.add(
            element["title"].substring(9, element["title"].length)); // Artista
      else if (element["title"].split(' ')[0] == "Anno")
        description.add(element["title"]
            .split(' ')[element["title"].split(' ').length - 1]); // Data uscita
    });
    description.add(mangaTrama[1]["title"].replaceAll("TRAMA", ''));
    values.add(description);

    // Prendo i capitoli
    List capsMangaCount = webScraper.getElement(
      "div.container > div.row > div.col-sm-12 > div.single-comic > div.has-shadow > div.section-body > div.chapters-wrapper > div.volume-element > div.volume-chapters > div.chapter > a.chap",
      ["title", "href"],
    );

    // In caso la pagina sia messa in modo diverso
    if (capsMangaCount.length == 0)
      capsMangaCount = webScraper.getElement(
        "div.container > div.row > div.col-sm-12 > div.single-comic > div.has-shadow > div.section-body > div.chapters-wrapper > div.chapter > a.chap",
        ["title", "href"],
      );

    // Salvo i capitoli dentro una variabile temporanea
    List capsManga = [];
    for (var item in capsMangaCount)
      capsManga.add([item["attributes"]["title"], item["attributes"]["href"]]);

    values.add(capsManga);
    return values;
  } else {
    print("Error");
    return null;
  }
}

// Funzione che ritorna il numero dei capitoli e delle pagine
Future initReading(String url) async {
  final webScraper = WebScraper('https://www.mangaworld.io');
  final endpoint = "$url".replaceAll("https://www.mangaworld.io", "");

  if (await webScraper.loadWebPage(endpoint)) {
    print("(initReading) Load...");

    // // Numeri dei capitoli totali in quel volume
    // var capsTotal = webScraper.getElement(
    //     "div.container > div.top > div.bottom-row > div.section-left > div.col-6 > select.chapter > option",
    //     ["value"]);

    // if (capsTotal.length == 0)
    //   capsTotal = webScraper.getElement(
    //       "div.container > div.top > div.bottom-row > div.container > div.section-left > div.col-6 > select.chapter > option",
    //       ["value"]);

    // Numeri delle pagine totali in quel capitolo
    var values = webScraper.getElement(
        "div.container > div.col-12 > div.bottom-row > div.section-right > div.col-6 > select.page > option",
        ["value"]);

    if (values.length == 0)
      values = webScraper.getElement(
          "div.container > div.top > div.bottom-row > div.container > div.section-right > div.col-6 > select.page > option",
          ["value"]);

    return int.parse(values[values.length - 1]["attributes"]["value"]) +
        1; // N.Capitoli
  } else {
    print("Error");
    return null;
  }
}

Future getImgFromLink(String url) async {
  final webScraper = WebScraper('https://www.mangaworld.io');
  final endpoint = "$url".replaceAll("https://www.mangaworld.io", "");

  if (await webScraper.loadWebPage(endpoint)) {
    print("(getImgFromLink) Load...");

    final img =
        webScraper.getElement("div.container > div.col-12 > img", ["src"]);

    return img;
  } else
    return null;
}

Future getNewUpdateManga() async {
  final webScraper = WebScraper('https://www.mangaworld.io');

  if (await webScraper.loadWebPage("")) {
    print("(getNewUpdateManga) Load...");

    final link = webScraper.getElement(
        "div.container > section.group-popular > div.row > div.col-12 > div.comics-flex > div > p",
        []);

    List manga = [];
    for (var item in link) manga.add(item["title"]);

    return manga.toSet().toList();
  } else
    return null;
}
