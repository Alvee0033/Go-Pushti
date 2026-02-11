import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_assessment.dart';

/// Simple local persistence for saved assessments using SharedPreferences.
class AssessmentStore {
  static const _key = 'saved_assessments';

  static Future<List<SavedAssessment>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list
        .map((s) => SavedAssessment.fromJson(
            jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> save(SavedAssessment assessment) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(jsonEncode(assessment.toJson()));
    await prefs.setStringList(_key, list);
  }

  static Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.removeWhere((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return map['id'] == id;
    });
    await prefs.setStringList(_key, list);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
