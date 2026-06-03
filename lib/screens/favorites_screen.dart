import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/disease.dart';
import '../data/diseases.dart';
import '../services/storage_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];
  bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { final f = await StorageService.getFavorites(); if (mounted) setState(() { _favorites = f; _loading = false; }); }
  Disease? _find(String id) { try { return allDiseases.firstWhere((d) => d.id == id); } catch (_) { return null; } }

  @override
  Widget build(BuildContext context) {
    final favD = _favorites.map(_find).whereType<Disease>().toList();
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('Merkliste', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), actions: [if (favD.isNotEmpty) Padding(padding: const EdgeInsets.only(right: 16), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.cyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: Text('${favD.length} Einträge', style: const TextStyle(color: AppTheme.cyan, fontSize: 11, fontWeight: FontWeight.w600))))]),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppTheme.cyan)) : favD.isEmpty ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('⭐', style: TextStyle(fontSize: 48)), SizedBox(height: 16), Text('Noch keine Favoriten', style: TextStyle(color: AppTheme.muted, fontSize: 14))])) : ListView.builder(padding: const EdgeInsets.all(16), itemCount: favD.length, itemBuilder: (_, i) {
        final d = favD[i];
        final c = d.urgency == 'akut' ? AppTheme.red : d.urgency == 'subakut' ? AppTheme.amber : AppTheme.green;
        return GestureDetector(onTap: () async { await StorageService.addRecent(d.id); if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(disease: d))).then((_) => _load()); }, child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(14)), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.cyan.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('📋', style: TextStyle(fontSize: 18)))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(d.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)), child: Text(d.urgency == 'akut' ? 'Akut' : d.urgency == 'subakut' ? 'Subakut' : 'Elektiv', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: c)))]), const SizedBox(height: 2), Text(d.summary, style: const TextStyle(fontSize: 12, color: AppTheme.muted), maxLines: 1, overflow: TextOverflow.ellipsis)])), GestureDetector(onTap: () async { await StorageService.toggleFavorite(d.id); _load(); }, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.star, color: AppTheme.amber, size: 18))), const SizedBox(width: 4), const Icon(Icons.chevron_right, color: AppTheme.muted, size: 20)])));
      }),
    );
  }
}
