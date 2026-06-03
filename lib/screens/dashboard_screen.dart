import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/disease.dart';
import '../data/diseases.dart';
import '../services/storage_service.dart';
import 'detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> _favorites = [];
  List<String> _recents = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _loadData(); }

  Future<void> _loadData() async {
    final favs = await StorageService.getFavorites();
    final recs = await StorageService.getRecents();
    if (mounted) setState(() { _favorites = favs; _recents = recs; _loading = false; });
  }

  Disease? _find(String id) { try { return allDiseases.firstWhere((d) => d.id == id); } catch (_) { return null; } }

  @override
  Widget build(BuildContext context) {
    final akut = allDiseases.where((d) => d.urgency == 'akut').length;
    final cats = allDiseases.map((d) => d.category).toSet().length;
    final favD = _favorites.map(_find).whereType<Disease>().toList();
    final recD = _recents.map(_find).whereType<Disease>().toList();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Row(children: [Icon(Icons.medical_services, color: AppTheme.cyan, size: 20), SizedBox(width: 8), Text('MediTool', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white))]), actions: [Container(margin: const EdgeInsets.only(right: 16), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppTheme.cyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: const Text('v1.2', style: TextStyle(color: AppTheme.cyan, fontSize: 10, fontWeight: FontWeight.w600)))]),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppTheme.cyan)) : ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Guten Dienst! 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        const Text('Alles griffbereit für deine Schicht.', style: TextStyle(fontSize: 14, color: AppTheme.muted)),
        const SizedBox(height: 20),
        Row(children: [_Stat(value: '${allDiseases.length}', label: 'Einträge', color: AppTheme.cyan), const SizedBox(width: 12), _Stat(value: '$akut', label: 'Akut', color: AppTheme.red), const SizedBox(width: 12), _Stat(value: '$cats', label: 'Kategorien', color: AppTheme.teal)]),
        const SizedBox(height: 20),
        if (favD.isNotEmpty) ...[const Text('⭐ Deine Merkliste', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)), const SizedBox(height: 8), ...favD.take(4).map((d) => _Tile(disease: d, onTap: () => _open(d))), const SizedBox(height: 20)],
        if (recD.isNotEmpty) ...[const Text('🕐 Zuletzt angesehen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)), const SizedBox(height: 8), ...recD.take(5).map((d) => _Tile(disease: d, onTap: () => _open(d)))],
        const SizedBox(height: 80),
      ]),
    );
  }

  void _open(Disease d) async { await StorageService.addRecent(d.id); if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(disease: d))).then((_) => _loadData()); }
}

class _Stat extends StatelessWidget {
  final String value, label; final Color color;
  const _Stat({required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.05))), child: Column(children: [Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.muted))])));
}

class _Tile extends StatelessWidget {
  final Disease disease; final VoidCallback onTap;
  const _Tile({required this.disease, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = disease.urgency == 'akut' ? AppTheme.red : disease.urgency == 'subakut' ? AppTheme.amber : AppTheme.green;
    return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.05))), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.cyan.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('📋', style: TextStyle(fontSize: 18)))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(disease.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis), Text(disease.category, style: const TextStyle(fontSize: 10, color: AppTheme.muted))])), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)), child: Text(disease.urgency == 'akut' ? 'Akut' : disease.urgency == 'subakut' ? 'Subakut' : 'Elektiv', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: c))), const SizedBox(width: 4), const Icon(Icons.chevron_right, color: AppTheme.muted, size: 20)])));
  }
}
