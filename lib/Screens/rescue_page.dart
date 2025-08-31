import 'package:flutter/material.dart';
import 'report_form.dart';

class RescuePage extends StatelessWidget {
  const RescuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("🚨 Rescue & Emergency"),
        backgroundColor: orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [orange, orange.withOpacity(.85)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10, offset: const Offset(0, 6))],
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
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportFormPage()));
                      },
                      icon: const Icon(Icons.report_gmailerrorred_rounded),
                      label: const Text("Report Missing Person", style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .2)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _InfoChip(icon: Icons.edit_note, text: "Details fill karo"),
                _InfoChip(icon: Icons.call, text: "Team ko alert"),
                _InfoChip(icon: Icons.volume_up, text: "Announcement hota hai"),
                _InfoChip(icon: Icons.place, text: "Last-seen pe reach"),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const Icon(Icons.local_hospital, color: Colors.deepOrange),
                title: const Text("Quick Helpline", style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text("Emergency number: 112"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Use 112 for emergencies")));
                },
              ),
            ),
            const SizedBox(height: 12),
            const _SectionCard(
              child: ListTile(
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
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: child,
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon; final String text;
  const _InfoChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.deepOrange),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.orange.shade200)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }
}
