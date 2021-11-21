import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DataX extends GetxController {
  var nameManga = "".obs; // Nome manga cercato
  var lastCap = [].obs; // Manga che si sta leggendo
  var resume_start = "Inizia".obs; // Pulsante inizia continua

  // Ricerca del nome
  updateManga(String name) {
    nameManga = name.obs;
    update();
  }

  // Aggiornare il pulsante Inizia o Continua
  searchLastManga(String nameManga) {
    for (var item in lastCap) if (nameManga == item[0]) return item;
    return null;
  }

  // Aggiornare la lista lastCap con i manga iniziati
  updateLastManga(String nameManga, int index, String url) {
    bool isInArry = false;
    for (var i in lastCap) {
      if (nameManga == i[0]) {
        isInArry = true;

        if (index < i[1][0]) {
          lastCap[lastCap.indexOf(i)][1][0] = index;
          lastCap[lastCap.indexOf(i)][1][1] = url;
          GetStorage().write("Manga", lastCap);
          break;
        }
      }
    }
    if (!isInArry) {
      lastCap.add([
        nameManga,
        [index, url]
      ]);
      GetStorage().write("Manga", lastCap);
    }
    resume_start = "Continua".obs;
    update();
  }

  // Salvo i manga localmente
  setMangaSaved() {
    if (lastCap.length == 0)
      for (var item in GetStorage().read("Manga")) lastCap.add(item);
    update();
  }

  // Funziona salva manga
  savedManga(List newManga, bool removeOrAdd) {
    List mangaSaved = GetStorage().read("MangaSaved");

    if (removeOrAdd)
      mangaSaved.add(newManga);
    else {
      int index = 0;
      for (int i = 0; i < mangaSaved.length; i += 1)
        if (mangaSaved[i][0] == newManga[0]) {
          index = i;
          break;
        }
      mangaSaved.removeAt(index);
    }

    GetStorage().write("MangaSaved", mangaSaved);
  }

  // Cercare se il manga è salvato
  mangaIsSaved(List manga) {
    for (var item in GetStorage().read("MangaSaved")) {
      if (manga[0] == item[0]) return true;
    }

    return false;
  }
}
