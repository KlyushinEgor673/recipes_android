import 'package:flutter/material.dart';
import 'package:recipes_android/sqlite_query.dart';

class HomeAd extends StatefulWidget {
  const HomeAd({super.key});

  @override
  State<HomeAd> createState() => _HomeAdState();
}

class _HomeAdState extends State<HomeAd> {
  Color _colorAdd = Colors.blueGrey;
  final _controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionColor: Colors.blueGrey.withAlpha(127),
            cursorColor: Colors.blueGrey,
            selectionHandleColor: Colors.blueGrey,
          ),
          child: TextField(
            style: TextStyle(fontSize: 18),
            controller: _controllerName,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Название',
              labelStyle: TextStyle(fontSize: 18, color: Colors.blueGrey),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _colorAdd, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'отмена',
            style: TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () async {
            bool isInsert = await insertRecipe(_controllerName.text);
            if (isInsert) {
              setState(() {
                _colorAdd = Colors.blueGrey;
                _controllerName.text = '';
              });
              Navigator.pop(context);
            } else {
              setState(() {
                _colorAdd = Colors.red;
              });
            }
          },
          child: Text(
            'создать',
            style: TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
