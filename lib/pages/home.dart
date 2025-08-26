import 'package:flutter/material.dart';
import 'package:recipes_android/sqlite_query.dart';
import 'package:recipes_android/widgets/home_ad.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _isLoading = true;
  List<Map> recipes = [];
  int _editI = -1;
  final _controllerEditI = TextEditingController();
  final _controllerSearch = TextEditingController();
  final FocusNode _focusNodeSearch = FocusNode();
  final FocusNode _focusNodeEditI = FocusNode();


  Future<void> _init() async {
    recipes = await selectRecipes();
    setState(() {
      _isLoading = false;
    });
  }

  void _handleFocusSearchSearch() {
    if (_focusNodeSearch.hasFocus){
      print('focus');
      setState(() {
        _editI = -1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNodeSearch.addListener(_handleFocusSearchSearch);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.blueGrey,
                  selectionHandleColor: Colors.blueGrey,
                  selectionColor: Colors.blueGrey.withAlpha(127),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  controller: _controllerSearch,
                  focusNode: _focusNodeSearch,
                  onChanged: (value) {
                    setState(() {
                      _controllerSearch;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black26, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 80),
                itemCount: recipes.length,
                itemBuilder: (BuildContext context, i) {
                  return recipes[i]['name'].startsWith(_controllerSearch.text)
                      ? _editI == i
                            ? Card(
                                color: Colors.white,
                                child: Expanded(
                                  child: TextSelectionTheme(
                                    data: TextSelectionThemeData(
                                      cursorColor: Colors.blueGrey,
                                      selectionHandleColor: Colors.blueGrey,
                                      selectionColor: Colors.blueGrey
                                          .withAlpha(127),
                                    ),
                                    child: TextField(
                                      focusNode: _focusNodeEditI,
                                      style: TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.blueGrey,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black26,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      autofocus: true,
                                      controller: _controllerEditI,
                                      onChanged: (value) async {
                                        await updateRecipe(
                                          recipes[i]['id'],
                                          _controllerEditI.text,
                                        );
                                      },
                                      onEditingComplete: () async {
                                        await updateRecipe(
                                          recipes[i]['id'],
                                          _controllerEditI.text,
                                        );
                                        recipes = await selectRecipes();
                                        setState(() {
                                          _editI = -1;
                                          recipes;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Card(
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              recipes[i]['name'],
                              style: TextStyle(fontSize: 18),
                            ),
                            margin: EdgeInsets.only(left: 15),
                          ),
                          PopupMenuButton(
                            color: Colors.white,
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 10),
                                    Text('Изменить'),
                                  ],
                                ),
                                value: 'edit',
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Удалить',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                value: 'delete',
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 'edit') {
                                setState(() {
                                  _editI = i;
                                  _controllerEditI.text =
                                  recipes[i]['name'];
                                  _focusNodeSearch.unfocus();
                                });
                              } else {
                                await deleteRecipe(
                                  recipes[i]['id'],
                                );
                                recipes = await selectRecipes();
                                setState(() {
                                  recipes;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/recipe',
                            arguments: {'recipes': recipes, 'i': i},
                          );
                          setState(() {
                            _editI = -1;
                          });
                          recipes = await selectRecipes();
                          setState(() {
                            recipes;
                          });
                        }
                    ),
                  ) : SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return HomeAd();
            },
          );
          recipes = await selectRecipes();
          setState(() {
            recipes;
          });
        },
      ),
    );
  }
}
