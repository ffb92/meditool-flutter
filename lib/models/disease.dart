class Tool { final String name; final String purpose; const Tool({required this.name, required this.purpose}); }
class Material { final String name; final String detail; const Material({required this.name, required this.detail}); }
class Medication { final String name; final String dosage; final String timing; const Medication({required this.name, required this.dosage, required this.timing}); }
class Source { final String name; final String url; final String description; const Source({required this.name, required this.url, required this.description}); }

class Disease {
  final String id, name, category, urgency, summary, notes;
  final List<String> symptoms, preparation;
  final List<Tool> tools;
  final List<Material> materials;
  final List<Medication> medications;
  final List<Source>? sources;
  const Disease({required this.id, required this.name, required this.category, required this.urgency, required this.summary, required this.symptoms, required this.tools, required this.materials, required this.medications, required this.preparation, required this.notes, this.sources});
  int get totalItems => tools.length + materials.length + medications.length + preparation.length;
}
