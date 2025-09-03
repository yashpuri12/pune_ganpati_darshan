import 'package:flutter/material.dart';
import '../data/mandals.dart';
import 'mandal_details_page.dart';
import 'report_form.dart';
import 'darshan_route_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';
  String _areaFilter = 'All';

  List<String> get _areas {
    final set = {'All', ...kMandals.map((e) => e.area)};
    return set.toList();
  }

  List<Mandal> get _filtered {
    return kMandals.where((m) {
      final q = _query.toLowerCase();
      final matchesQuery =
          q.isEmpty || m.name.toLowerCase().contains(q) || m.area.toLowerCase().contains(q);
      final matchesArea = _areaFilter == 'All' || m.area == _areaFilter;
      return matchesQuery && matchesArea;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: orange,
        title: const Text("Welcome"),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // ---------------- Rescue Card ----------------
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [orange, orange.withOpacity(.85)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.campaign, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Need to find a family member in the crowd? Report quickly.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: orange,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ReportFormPage()),
                      );
                    },
                    icon: const Icon(Icons.report_gmailerrorred_rounded),
                    label: const Text(
                      "Report Missing Person",
                      style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _InfoChip(icon: Icons.edit_note, text: "Fill in the details✅"),
              _InfoChip(icon: Icons.call, text: "Alert the team"),
            ],
          ),
          const SizedBox(height: 20),

          // 🚩 Start Darshan Route Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white, width: 6), // ✅ White Border
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DarshanRoutePage()),
                );
              },
              icon: Image.asset(
                "assets/icon/Ganesh2.png", // ✅ tujhka diya hua path
                width: 38,
                height: 38,
              ),
              label: const Text(
                "Start Pune Ganpati Darshan",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),




          const SizedBox(height: 12),

          _SectionCard(
            child: const ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Icon(Icons.info, color: Colors.deepOrange),
              title: Text("Important Tips", style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                "• Make an announcement at the police booth\n"
                    "• Stop and wait at the last-seen spot\n"
                    "• Keep the phone line free\n"
                    "• Teach children to remember their name and   phone number",
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ================== Manacha Top 5 ==================
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            child: Row(
              children: const [
                Icon(Icons.verified, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  "Manache Pahile 5 Ganpati",
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          ManachaTopFive(
            onTapMandal: (m) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MandalDetailsPage(mandal: m)),
              );
            },
          ),
          const SizedBox(height: 8),

          // ---------------- Mandals Section ----------------
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: "Search by name or area...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: PopupMenuButton<String>(
                  initialValue: _areaFilter,
                  onSelected: (v) => setState(() => _areaFilter = v),
                  itemBuilder: (_) =>
                      _areas.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.filter_list, color: Colors.deepOrange),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _areaFilter,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (_filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text("No mandals match your search."),
              ),
            )
          else
            ..._filtered.map((m) => _MandalCard(mandal: m, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MandalDetailsPage(mandal: m)),
              );
            })),
        ],
      ),
    );
  }
}

// ===== Helper Widgets =====
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10, offset: const Offset(0, 6))
      ],
    ),
    child: child,
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 18, color: Colors.deepOrange),
    label: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    backgroundColor: Colors.white,
    shape: StadiumBorder(side: BorderSide(color: Colors.orange.shade200)),
  );
}

class _MandalCard extends StatelessWidget {
  final Mandal mandal;
  final VoidCallback onTap;
  const _MandalCard({required this.mandal, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10)],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: ListTile(
        leading: _leadingImage(mandal.image),
        title: Text(mandal.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(mandal.area),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    ),
  );

  Widget _leadingImage(String? assetPath) {
    final placeholder = const CircleAvatar(
      radius: 28,
      backgroundColor: Color(0xFFFFE0B2),
      child: Icon(Icons.temple_hindu, color: Colors.deepOrange),
    );
    final tag = mandal.name;

    if (assetPath == null) {
      return Hero(tag: tag, child: placeholder);
    }
    return Hero(
      tag: tag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          assetPath,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}

// ================== Manacha Top 5 ==================
class ManachaTopFive extends StatelessWidget {
  final void Function(Mandal) onTapMandal;
  const ManachaTopFive({super.key, required this.onTapMandal});

  @override
  Widget build(BuildContext context) {
    final top5 = kMandals
        .where((m) => m.tag == "Manacha")
        .toList()
      ..sort((a, b) => (a.manachaRank ?? 999).compareTo(b.manachaRank ?? 999));

    if (top5.isEmpty) return const SizedBox.shrink();

    final screenW = MediaQuery.of(context).size.width;
    final cardW = (screenW - 16 * 2 - 12) / 2;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final m in top5)
            _ManachaCard(
              mandal: m,
              width: cardW,
              onTap: () => onTapMandal(m),
            ),
        ],
      ),
    );
  }
}

class _ManachaCard extends StatelessWidget {
  final Mandal mandal;
  final double width;
  final VoidCallback onTap;
  const _ManachaCard({
    required this.mandal,
    required this.width,
    required this.onTap,
  });

  String _rankLabel(int r) {
    switch (r) {
      case 1:
        return "Pahila Manacha Ganpati";
      case 2:
        return "Dusra Manacha Ganpati";
      case 3:
        return "Tisra Manacha Ganpati";
      case 4:
        return "Chautha Manacha Ganpati";
      case 5:
        return "Pachava Manacha Ganpati";
      default:
        return "Manacha Ganpati";
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = mandal.manachaRank ?? 0;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: width,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.deepOrange.shade400, Colors.deepOrange.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(.18),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _thumb(mandal.image),
              ),
              const SizedBox(height: 8),
              Text(
                _rankLabel(r),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumb(String? path) {
    final placeholder = Container(
      width: 60,
      height: 60,
      color: Colors.white.withOpacity(.12),
      child: const Icon(Icons.temple_hindu, color: Colors.white, size: 24),
    );
    if (path == null) return SizedBox(width: 60, height: 60, child: placeholder);
    return Image.asset(
      path,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => SizedBox(width: 60, height: 60, child: placeholder),
    );
  }
}
