import 'package:flutter/material.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/services/dbhelper.dart';
import 'package:quil/test/constants.dart';

class Notesprovider extends ChangeNotifier {
  final String userId;
  Notesprovider(this.userId);
  List<Note> _notes = [];
  List<Note> get notes => _notes;
  List<Note> _delnotes = [];
  List<Note> get delnotes => _delnotes;

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
    await recyclebin(localuser);
  }

  Future<void> recyclebin(String userId) async {
    _delnotes = await Dbhelper.deletedlist(userId);
    notifyListeners();
  }

  Future<void> restore(Note note) async {
    await Dbhelper.restore(note.id);
    await loadnotes();
    await recyclebin(localuser);
  }
}
