import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LostFoundPage extends StatefulWidget {
  const LostFoundPage({super.key});
  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  final lostItems = <Map<String, String>>[];
  final foundItems = <Map<String, String>>[];

  Future<File?> _pickAndPersist(ImageSource source) async {
    final x = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (x == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final dst = File(p.join(dir.path, 'lf_${DateTime.now().millisecondsSinceEpoch}${p.extension(x.path)}'));
    return File(x.path).copy(dst.path);
  }

  Future<void> _openAddSheet({required bool isLost}) async {
    final titleC = TextEditingController();
    final placeC = TextEditingController();
    final phoneC = TextEditingController();
    File? photo;

    await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(left:16,right:16,top:16,bottom:16+MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(isLost ? "➕ Report Lost Item" : "➕ Report Found Item",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              const SizedBox(height: 16),
              Row(children: [
                CircleAvatar(
                  radius: 36, backgroundColor: Colors.orange.shade100,
                  backgroundImage: photo != null ? FileImage(photo!) : null,
                  child: photo == null ? const Icon(Icons.image, size: 36, color: Colors.deepOrange) : null,
                ),
                const SizedBox(width: 12),
                Expanded(child: Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton.icon(
                    onPressed: () async { final f = await _pickAndPersist(ImageSource.camera); if (f != null) setS(() => photo = f); },
                    icon: const Icon(Icons.photo_camera), label: const Text("Camera"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async { final f = await _pickAndPersist(ImageSource.gallery); if (f != null) setS(() => photo = f); },
                    icon: const Icon(Icons.photo_library), label: const Text("Gallery"),
                  ),
                ])),
              ]),
              const SizedBox(height: 16),
              TextField(controller: titleC, decoration: const InputDecoration(labelText: "Item Name / Description", prefixIcon: Icon(Icons.edit), filled: true)),
              const SizedBox(height: 8),
              TextField(controller: placeC, decoration: const InputDecoration(labelText: "Where (Place/Area)", prefixIcon: Icon(Icons.place), filled: true)),
              const SizedBox(height: 8),
              TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Contact Number (optional)", prefixIcon: Icon(Icons.phone), filled: true)),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  final t = titleC.text.trim(), p1 = placeC.text.trim();
                  if (t.isEmpty || p1.isEmpty) return;
                  final data = <String, String>{"title": t, "place": p1, "phone": phoneC.text.trim(), if (photo != null) "imagePath": photo!.path};
                  setState(() { if (isLost) lostItems.add(data); else foundItems.add(data); });
                  Navigator.pop(ctx);
                },
                child: Text(isLost ? "Add Lost" : "Add Found"),
              )),
            ]),
          ),
        ),
      ),
    );
  }

  void _openImageViewer(String path) {
    showDialog(context: context, builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: InteractiveViewer(child: Image.file(File(path), fit: BoxFit.contain)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("🛑 LOST & FOUND", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          backgroundColor: Colors.deepOrange,
          bottom: const TabBar(indicatorColor: Colors.white, tabs: [
            Tab(child: Text("📕 Lost", style: TextStyle(fontWeight: FontWeight.bold))),
            Tab(child: Text("📗 Found", style: TextStyle(fontWeight: FontWeight.bold))),
          ]),
        ),
        body: TabBarView(children: [
          _buildList(lostItems, isLost: true),
          _buildList(foundItems, isLost: false),
        ]),
        floatingActionButton: Builder(
          builder: (ctx) {
            final isLost = DefaultTabController.of(ctx).index == 0;
            return FloatingActionButton.extended(
              backgroundColor: Colors.deepOrange,
              onPressed: () => _openAddSheet(isLost: isLost),
              icon: const Icon(Icons.add),
              label: Text(isLost ? "Add Lost" : "Add Found"),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, String>> items, {required bool isLost}) {
    if (items.isEmpty) {
      return Center(child: Text(isLost ? "No lost items yet." : "No found items yet.",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final it = items[i]; final img = it["imagePath"];
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3))]),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: (img != null && img.isNotEmpty && File(img).existsSync())
                ? GestureDetector(
              onTap: () => _openImageViewer(img),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(img), width: 60, height: 60, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40)),
              ),
            )
                : Icon(isLost ? Icons.search : Icons.inventory_2, color: Colors.deepOrange, size: 40),
            title: Text(it["title"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text("${it["place"] ?? ""}${(it["phone"] ?? "").isNotEmpty ? "\n☎ ${it["phone"]}" : ""}", style: const TextStyle(height: 1.4)),
          ),
        );
      },
    );
  }
}
