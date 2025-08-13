import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:recipes_android/sqlite_query.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key, required this.recipes, required this.i});

  final List<Map> recipes;
  final int i;

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  Future<void> _updateImageInDB() async {
    List listBase64 = [];
    for (var bytes in _listBytes) {
      listBase64.add(base64Encode(bytes));
    }
    String listBase64String = jsonEncode(listBase64);
    await updateImages(widget.recipes[widget.i]['id'], listBase64String);
  }

  Future<void> _getImages() async {
    ImagePicker picker = ImagePicker();
    List<XFile> listImage = await picker.pickMultiImage();
    if (listImage.length > 0) {
      final Directory dirApp = await getApplicationDocumentsDirectory();
      for (int i = 0; i < listImage.length; ++i) {
        final String savePath =
            '${dirApp.path}/${widget.recipes[widget.i]['id']}_$i.jpg';
        final File imageFile = File(listImage[i].path);
        await imageFile.copy(savePath);
        var bytes = await listImage[i].readAsBytes();
        _listBytes.add(bytes);
      }
      // for (XFile image in listImage) {
      //   var bytes = await image.readAsBytes();
      //   _listBytes.add(bytes);
      // }
      // await _updateImageInDB();
      setState(() {
        _listBytes;
      });
    }
  }

  List _listBytes = [];
  TextEditingController _controller = TextEditingController();
  PageController _controllerPage = PageController(initialPage: 0);
  int _currentPage = 0;

  Future<void> _init() async {
    _controller.text = widget.recipes[widget.i]['description'];
    final Directory dirApp = await getApplicationDocumentsDirectory();
    final files = dirApp.listSync();
    List _listBytesTime = [];
    for (var file in files) {
      if (file.path
              .split('/')
              .last
              .startsWith(widget.recipes[widget.i]['id'].toString()) &&
          file.path.split('/').last.endsWith('.jpg')) {
        _listBytesTime.add(await File(file.path).readAsBytes());
      }
    }
    setState(() {
      _listBytes = _listBytesTime;
    });
    // _listBytes =
    // await Future.wait(
    //   files.where((file) {
    //     final fileName = file.path;
    //     print(fileName);
    //     return true;
    //   }).map((file) => File(file.path).readAsBytes()),
    // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // List listBase64 = jsonDecode(widget.recipes[widget.i]['images']);
    // for (var base64 in listBase64) {
    //   _listBytes.add(base64Decode(base64));
    // }
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.recipes[widget.i]['name']),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.blueGrey,
        ),
      ),
      body: ListView(
        children: [
          _listBytes.length == 0
              ? InkWell(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Icon(Icons.add),
                    ),
                  ),
                  onTap: _getImages,
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 4 / 3,
                      child: PageView(
                        controller: _controllerPage,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: _listBytes
                            .asMap()
                            .entries
                            .map<Widget>(
                              (entry) => Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.black),
                                child: AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: Stack(
                                    children: [
                                      Center(child: Image.memory(entry.value)),
                                      Positioned(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(127),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            onTap: () async {
                                              _listBytes.removeAt(entry.key);
                                              await _updateImageInDB();
                                              setState(() {
                                                _listBytes;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Icon(Icons.delete),
                                            ),
                                          ),
                                        ),
                                        top: 20,
                                        right: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: 10,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(
                                  127,
                                ), // Shadow color
                                offset: Offset(0, 5), // Shadow offset (x, y)
                                blurRadius: 1, // Blur intensity
                                spreadRadius: 1, // Shadow expansion
                              ),
                            ],
                          ),
                          child: Icon(Icons.add_a_photo),
                        ),
                        onTap: () async {
                          ImagePicker picker = ImagePicker();
                          List<XFile> listImage = await picker.pickMultiImage();
                          for (XFile image in listImage) {
                            var bytes = await image.readAsBytes();
                            _listBytes.add(bytes);
                          }
                          _controllerPage.jumpToPage(0);
                          setState(() {
                            _currentPage = 0;
                            _listBytes;
                          });
                          await _updateImageInDB();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      color: Colors.grey.withAlpha(70),
                      child: Row(
                        children: _listBytes
                            .asMap()
                            .entries
                            .map<Widget>(
                              (entry) => Container(
                                height: 7,
                                width:
                                    MediaQuery.of(context).size.width /
                                        _listBytes.length -
                                    5,
                                margin: EdgeInsets.only(right: 2.5, left: 2.5),
                                decoration: BoxDecoration(
                                  color: entry.key == _currentPage
                                      ? Colors.white.withAlpha(200)
                                      : Colors.white.withAlpha(127),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextSelectionTheme(
              data: TextSelectionThemeData(
                selectionColor: Colors.blueGrey.withAlpha(127),
                cursorColor: Colors.blueGrey,
                selectionHandleColor: Colors.blueGrey,
              ),
              child: TextField(
                maxLines: null,
                onChanged: (value) {
                  updateDescription(widget.recipes[widget.i]['id'], value);
                },
                decoration: InputDecoration(
                  hintText: 'Введите рецепт',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 18),
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
