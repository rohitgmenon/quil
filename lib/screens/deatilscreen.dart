import 'package:flutter/material.dart';

class Deatilscreen extends StatefulWidget {
  const Deatilscreen({super.key});

  @override
  State<Deatilscreen> createState() => _DeatilscreenState();
}

class _DeatilscreenState extends State<Deatilscreen> {
  static final _importance = ['High', 'Low'];
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                items: _importance.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                value: 'Low',
                onChanged: (valueSelect) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _title,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(
              height: 550,
              child: TextField(
                controller: _content,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Your Note',
                  hintText: "What's on your Mind",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(width: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: () {}, child: Text("Save")),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
