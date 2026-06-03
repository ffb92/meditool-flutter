import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _fav = 'meditool_favorites';
  static const _rec = 'meditool_recents';
  static const _chk = 'meditool_checklists';

  static Future<List<String>> getFavorites() async {
    return (await SharedPreferences.getInstance()).getStringList(_fav) ?? [];
  }
  static Future<void> toggleFavorite(String id) async {
    final p = await SharedPreferences.getInstance();
    final f = p.getStringList(_fav) ?? [];
    f.contains(id) ? f.remove(id) : f.insert(0, id);
    await p.setStringList(_fav, f);
  }
  static Future<bool> isFavorite(String id) async => (await getFavorites()).contains(id);
  
  static Future<List<String>> getRecents() async {
    return (await SharedPreferences.getInstance()).getStringList(_rec) ?? [];
  }
  static Future<void> addRecent(String id) async {
    final p = await SharedPreferences.getInstance();
    final r = p.getStringList(_rec) ?? [];
    r.remove(id); r.insert(0, id);
    if (r.length > 8) r.removeLast();
    await p.setStringList(_rec, r);
  }
  
  static Future<List<String>> getCheckedItems(String did) async {
    final all = (await SharedPreferences.getInstance()).getStringList(_chk) ?? [];
    return all.where((e) => e.startsWith('$did:')).map((e) => e.substring(did.length + 1)).toList();
  }
  static Future<void> toggleCheckItem(String did, String item) async {
    final p = await SharedPreferences.getInstance();
    final a = p.getStringList(_chk) ?? [];
    final k = '$did:$item';
    a.contains(k) ? a.remove(k) : a.add(k);
    await p.setStringList(_chk, a);
  }
  static Future<void> resetChecklist(String did) async {
    final p = await SharedPreferences.getInstance();
    final a = p.getStringList(_chk) ?? [];
    a.removeWhere((e) => e.startsWith('$did:'));
    await p.setStringList(_chk, a);
  }
}
