import 'dart:io';
import 'package:flutter/material.dart';

import '../data/mandals.dart';
import 'mandal_details_page.dart';
import 'report_form.dart';

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
                        "Kisi family member ko bheed me dhundhna hai? Jaldi report bhejo.",
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
              _InfoChip(icon: Icons.edit_note, text: "Details fill karo"),
              _InfoChip(icon: Icons.call, text: "Team ko alert"),
              _InfoChip(icon: Icons.volume_up, text: "Announcement hota hai"),
              _InfoChip(icon: Icons.place, text: "Last-seen pe reach"),
            ],
          ),

          const SizedBox(height: 12),

          _SectionCard(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const Icon(Icons.local_hospital, color: Colors.deepOrange),
              title: const Text("Quick Helpline", style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text("Emergency number: 112"),
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            child: const ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Icon(Icons.info, color: Colors.deepOrange),
              title: Text("Important Tips", style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                "• Police booth par announce karen\n"
                    "• Last-seen spot par rukkar wait karein\n"
                    "• Phone line free rakhein\n"
                    "• Bachchon ko naam/number yaad karayein",
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ================== Manacha Top 5 (Hero Section) ==================
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            child: Row(
              children: const [
                Icon(Icons.verified, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  "Manacha Pahila — Pachva",
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
              Icon(Icons.temple_hindu, color: orange),
              const SizedBox(width: 8),
              const Text(
                "Pune Ganpati Mandals (2025)",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.5),
              ),
            ],
          ),
          const SizedBox(height: 10),

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
              PopupMenuButton<String>(
                initialValue: _areaFilter,
                onSelected: (v) => setState(() => _areaFilter = v),
                itemBuilder: (_) =>
                    _areas.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, color: Colors.deepOrange),
                      const SizedBox(width: 6),
                      Text(_areaFilter, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
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
    final tag = mandal.name; // unique hero tag

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

// ================== Manacha Top 5 (2 columns grid) ==================
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

    // 2 columns: (screenW - horizontal padding*2 - gap) / 2
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

  Color _rankColor(int r) {
    switch (r) {
      case 1:
        return const Color(0xFFFFC107); // gold
      case 2:
        return const Color(0xFFB0BEC5); // silver
      case 3:
        return const Color(0xFFCD7F32); // bronze
      default:
        return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = mandal.manachaRank ?? 0;
    final pillBg = Colors.white.withOpacity(.15);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: width,
        height: 130, // compact height to avoid overflow
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
        child: Stack(
          children: [
            // rank badge
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _rankColor(r),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  r > 0 ? "Manacha $r" : "Manacha",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ),

            // contenta
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  // thumbnail (safe placeholder)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _thumb(mandal.image),
                  ),
                  const SizedBox(width: 10),
                  // text + pills
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mandal.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mandal.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                          ),
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _miniPill(Icons.login, "Entry", mandal.entry, pillBg),
                            _miniPill(Icons.schedule, "", mandal.timings, pillBg),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget _miniPill(IconData icon, String label, String value, Color bg) {
    final text = label.isEmpty ? value : "$label: $value";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white.withOpacity(.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
