import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quil/components/codebar.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/screens/ouputscreen.dart';
import 'package:quil/services/codeprovider.dart';
import 'package:quil/services/pistonreq.dart';
import '../services/api.dart';
import 'package:provider/provider.dart';

class Editor extends StatefulWidget {
  final Code? snip;
  const Editor({super.key, this.snip});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late TextEditingController _noteController;
  late TextEditingController _filenameController;
  final _inputController = TextEditingController(); // Add this
  String lang = 'python';
  String selectedLanguage = 'python';
  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.snip?.code ?? '');
    _filenameController = TextEditingController(
      text: widget.snip?.filename ?? '',
    );

    selectedLanguage = widget.snip?.lang ?? 'python';
  }

  @override
  void dispose() {
    _noteController.dispose();
    _filenameController.dispose();
    _inputController.dispose(); // Add this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'IDE',
          style: GoogleFonts.dmSerifText(
            fontSize: 28,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: TextField(
              controller: _filenameController,
              decoration: InputDecoration(
                hintText: 'Filename ',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.inversePrimary.withValues(alpha: .5),
                  fontSize: 16,
                ),
              ),
              style: GoogleFonts.sourceCodePro(fontSize: 15),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 10.0,
                right: 10.0,
                bottom: 10.0,
              ),
              child: TextField(
                controller: _noteController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Start coding...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .5),
                    fontSize: 16,
                  ),
                ),
                style: GoogleFonts.sourceCodePro(fontSize: 15, height: 1.5),
              ),
            ),
          ),
          // Add this input field
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: TextField(
              controller: _inputController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Input (optional - for programs that need input)',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.inversePrimary.withValues(alpha: .5),
                  fontSize: 14,
                ),
              ),
              style: GoogleFonts.sourceCodePro(fontSize: 14),
            ),
          ),
          Codebar(
            onsavepress: save,
            ondeletepress: () {
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
                                setState(() => lang = selectedLanguage);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: [
                              'python',
                              'javascript',
                              'java',
                              'c',
                              'cpp',
                            ].indexOf(lang),
                          ),
                          itemExtent: 50,
                          onSelectedItemChanged: (index) {
                            selectedLanguage = [
                              'python',
                              'javascript',
                              'java',
                              'c',
                              'cpp',
                            ][index];
                          },
                          children: [
                            Center(
                              child: Text(
                                '🐍 Python',
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
                                '📜 JavaScript',
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
                                '☕ Java',
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
                                '🔧 C',
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
                                '⚙️ C++',
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
              // Language/settings picker
            },
            onfixpress: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return Center(child: CircularProgressIndicator());
                },
              );
              final corrected = await debugger(_noteController.text);
              setState(() {
                _noteController.text = corrected;
              });
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            oncampress: compile,
          ),
        ],
      ),
    );
  }

  Future<void> compile() async {
    final input = _noteController.text;
    final stdin = _inputController.text; // Get user input

    final output = await compiler(input, lang, stdin); // Pass stdin
    if (output.isNotEmpty) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OutputScreen(output: output)),
      );
    }
  }

  void save() async {
    if (_noteController.text.isEmpty || _filenameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }
    final snip = Code(
      filename: _filenameController.text,
      code: _noteController.text,
      lang: lang,
      id: widget.snip?.id,
    );
    if (widget.snip == null) {
      context.read<Codeprovider>().addCode(snip);
    } else {
      context.read<Codeprovider>().updateCode(snip);
    }

    Navigator.pop(context);
  }
}
