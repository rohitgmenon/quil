import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/test/constants.dart';

class Deatilscreen extends StatefulWidget {
  final Note? notes;
  const Deatilscreen({super.key, this.notes});

  @override
  State<Deatilscreen> createState() => _DeatilscreenState();
}

class _DeatilscreenState extends State<Deatilscreen> {
  static final _importance = ['High', 'Low'];
  late TextEditingController _title;
  late TextEditingController _content;
  late int importance;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.notes?.title ?? '');
    _content = TextEditingController(text: widget.notes?.content ?? '');
    importance = widget.notes?.importance ?? 1;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_title.text.isEmpty || _content.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final note = Note(
      userId: localuser,
      id: widget.notes?.id,
      title: _title.text,
      content: _content.text,
      importance: importance,
      created: widget.notes?.created ?? DateTime.now(),
    );

    if (widget.notes == null) {
      context.read<Notesprovider>().addnote(note);
    } else {
      context.read<Notesprovider>().updatenote(note);
    }

    Navigator.pop(context);
  }

  void _deleteNote() {
    if (widget.notes != null) {
      context.read<Notesprovider>().deletenote(widget.notes!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton<String>(
                items: _importance.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                value: importance == 1 ? 'High' : 'Low',
                onChanged: (valueSelect) {
                  setState(() {
                    importance = valueSelect == 'High' ? 1 : 2;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _title,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(
              height: 550,
              child: TextFormField(
                controller: _content,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'your note',
                  hintText: "What's on your Mind",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(width: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveNote();
                    },
                    child: Text("Save"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.notes != null
                        ? () {
                            _deleteNote();
                          }
                        : null,
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
