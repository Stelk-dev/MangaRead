import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mangaread/functions/widgetsMangaVolume.dart';
import 'package:mangaread/mangaCapsPage.dart';
import 'functions/getXData.dart';
import 'functions/webScraping.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  if (GetStorage().read("MangaSaved") == null) // Settaggio dei dati locali
    GetStorage().write("MangaSaved", []);

  if (GetStorage().read("Manga") == null) GetStorage().write("Manga", []);

  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(builder: (context) {
    return MaterialApp(
      home: MyApp(),
      title: 'Manga Read',
      theme: ThemeData.dark(),
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
    );
  }));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = Get.put(DataX());
  final keyTextFormField = GlobalKey<FormState>();
  final FunctionManga functionManga = new FunctionManga();
  Future function;
  var i = 0.obs; // index of pages

  futureAwait() async {
    return await getNewUpdateManga();
  }

  @override
  void initState() {
    super.initState();
    function = futureAwait();
  }

  Widget home(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Form(
        key: keyTextFormField,
        child: Container(
            width: 300,
            child: TextFormField(
              textInputAction: TextInputAction.go,
              onEditingComplete: () {
                if (controller.nameManga.value.length != 0)
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CapsPage()));
                keyTextFormField.currentState.reset();
              },
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => controller.updateManga(value),
              decoration: InputDecoration(
                  hintText: 'Cerca manga',
                  hintStyle: TextStyle(fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(90, 222, 180, 1)),
                      borderRadius: BorderRadius.circular(40)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40)),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (keyTextFormField.currentState.validate())
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CapsPage()));
                        keyTextFormField.currentState.reset();
                      },
                    ),
                  )),
              validator: (value) {
                if (value.isEmpty)
                  return "Inserire nome manga";
                else
                  return null;
              },
              style: TextStyle(fontSize: 22),
            )),
      ),
    );
  }

  Widget mangaSectionSaved(BuildContext context) {
    List<Widget> children = [];
    final double itemHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = MediaQuery.of(context).size.width / 1.48;

    for (var item in GetStorage().read("MangaSaved"))
      children.add(FunctionManga()
          .cardImgMangaSvd(item[0], item[1][0], item[1][1], item[2], context));

    return Center(
      child: children.length != 0
          ? GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              padding: EdgeInsets.all(8),
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              children: children,
            )
          : Center(
              child: Text("Nessun manga salvato"),
            ),
    );
  }

  Widget mangaInTop(BuildContext context) {
    return FutureBuilder(
        future: function,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
                itemCount: snapshot.data.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tendenze di oggi: ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    );
                  else
                    return functionManga.mangaUps(
                        snapshot.data[index - 1], context);
                });
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetBuilder<DataX>(
      builder: (builder) => Scaffold(
        appBar: AppBar(
          title: Text('Manga Read'),
        ),
        body: i.value == 0
            ? home(context)
            : i.value == 1
                ? mangaInTop(context)
                : mangaSectionSaved(context),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: i.value,
            selectedItemColor: Color.fromRGBO(104, 254, 223, 1),
            unselectedItemColor: Colors.grey,
            backgroundColor: Color.fromRGBO(33, 33, 33, 1),
            onTap: (index) {
              i = index.obs;
              controller.update();
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department), label: 'tendenze'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book), label: 'manga')
            ]),
      ),
    );
  }
}
