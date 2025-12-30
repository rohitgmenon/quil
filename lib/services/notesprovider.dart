import 'package:flutter/material.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/services/dbhelper.dart';

class Notesprovider extends ChangeNotifier {
  final String userId;
  Notesprovider(this.userId);
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> loadnotes() async {
    _notes = await Dbhelper.fetch(userId);
    notifyListeners();
  }

  Future<void> addnote(Note note) async {
    await Dbhelper.addnote(note);
    await loadnotes();
  }

  Future<void> updatenote(Note note) async {
    await Dbhelper.updateNote(note);
    await loadnotes();
  }

  Future<void> deletenote(Note note) async {
    await Dbhelper.deletenote(note);
    await loadnotes();
  }
}
