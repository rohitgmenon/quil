import 'package:flutter/material.dart';
import 'package:quil/loacaldb/dbhelper.dart';
import 'package:quil/loacaldb/notemodel.dart';

class Codeprovider extends ChangeNotifier {
  List<Code> _codes = [];
  List<Code> get codes => _codes;
  Future<void> loadCodes() async {
    _codes = await Dbhelper.getAll();
    notifyListeners();
  }

  Future<void> addCode(Code code) async {
    await Dbhelper.insert(code);
    await loadCodes();
  }

  Future<void> updateCode(Code code) async {
    await Dbhelper.update(code);
    final index = _codes.indexWhere((c) => c.id == code.id);
    if (index != -1) {
      _codes[index] = code;
      notifyListeners();
    }
  }

  Future<void> deleteCode(Code code) async {
    if (code.id == null) return;
    await Dbhelper.delete(code.id!);
    _codes.removeWhere((c) => c.id == code.id);
    notifyListeners();
  }

  Future<Code?> getCodeById(int id) async {
    return await Dbhelper.getById(id);
  }
}
