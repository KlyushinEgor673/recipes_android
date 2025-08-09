import 'package:flutter/material.dart';
import 'package:recipes_android/sqlite_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controllerName = TextEditingController();
  bool _isLoading = true;
  List<Map> recipes = [];

  Future<void> _init() async {
    recipes = await selectRecipes();
    setState(() {
      recipes;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (BuildContext context, i) {
                      return InkWell(
                        child: Card(child: Text(recipes[i]['name'])),
                        onTap: (){
                          Navigator.pushNamed(context, '/recipe', arguments: {
                            'recipes': recipes,
                            'i': i
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(controller: _controllerName),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('отмена'),
                        ),
                        TextButton(
                          onPressed: () {
                            insertRecipe(_controllerName.text);
                            Navigator.pop(context);
                          },
                          child: Text('создать'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
  }
}
