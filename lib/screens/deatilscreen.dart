import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quil/components/bottombar.dart';
import 'package:quil/components/summarysheet.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/services/api.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/test/constants.dart';

class Deatilscreen extends StatefulWidget {
  final Note? notes;
  const Deatilscreen({super.key, this.notes});

  @override
  State<Deatilscreen> createState() => _DeatilscreenState();
}

class _DeatilscreenState extends State<Deatilscreen> {
  late TextEditingController _title;
  late TextEditingController _content;
  late int importance;
  String? summary;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.notes?.title ?? '');
    _content = TextEditingController(text: widget.notes?.content ?? '');
    importance = widget.notes?.importance ?? 1;
    summary = widget.notes?.summary;
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
      summary: summary,
      importance: importance,
      created: widget.notes?.created ?? DateTime.now(),
      isSynced: false,
      updated: widget.notes?.created ?? DateTime.now(),
    );

    if (widget.notes == null) {
      context.read<Notesprovider>().addnote(note);
    } else {
      context.read<Notesprovider>().updatenote(note);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Notes')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                top: 15.0,
                left: 10.0,
                right: 10.0,
                bottom: 80.0,
              ),
              children: [
                SizedBox(height: 8),
                TextFormField(
                  controller: _title,

                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
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
              ],
            ),
          ),
          Bottombar(
            onsavepress: _saveNote,
            ondeletepress: () {
              int selectedImportance = importance;

              showCupertinoModalPopup(
                context: context,
                builder: (context) => Container(
                  height: 250,
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),

                            CupertinoButton(
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                              ),
                              onPressed: () {
                                setState(() => importance = selectedImportance);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: importance - 1,
                          ),
                          itemExtent: 50,
                          onSelectedItemChanged: (index) {
                            selectedImportance = index + 1;
                          },
                          children: [
                            Center(
                              child: Text(
                                '⚠️ High Priority',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '📝 Low Priority',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onfixpress: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return Center(child: CircularProgressIndicator());
                },
              );
              final corrected = await spellfixer(_content.text);
              setState(() {
                _content.text = corrected;
              });
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            oncampress: () => Opensummary(context, content: _content.text),
          ),
        ],
      ),
    );
  }

  Future<void> Opensummary(BuildContext ctx, {required String content}) async {
    final newsummary = await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) =>
          Summarysheet(content: _content.text, initialsummary: summary),
    );

    if (newsummary != null) {
      setState(() {
        // Empty string means delete, null means cancelled
        summary = newsummary.trim().isEmpty ? null : newsummary;
      });
      if (!mounted) return;

      if (newsummary.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Summary deleted'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }
}
