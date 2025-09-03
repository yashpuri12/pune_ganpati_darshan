import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});
  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final ageC = TextEditingController();
  final guardianPhoneC = TextEditingController();
  final clothesC = TextEditingController();
  final descC = TextEditingController();

  String? lastSeenAt;
  File? photoFile;
  bool sending = false;

  final lastSeenOptions = const [
    "Dagadusheth Halwai Ganpati","Kasba Ganpati","Tulshibaug Ganpati","Shreemant Bhausaheb Rangari",
    "Akhil Mandai","Jangli Maharaj Road","FC Road","Swargate",
  ];

  @override
  void dispose() { nameC.dispose(); ageC.dispose(); guardianPhoneC.dispose(); clothesC.dispose(); descC.dispose(); super.dispose(); }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final x = await ImagePicker().pickImage(source: source, imageQuality: 70);
      if (x == null) return;
      final dir = await getApplicationDocumentsDirectory();
      final file = File(x.path);
      final saveAs = File(p.join(dir.path, "missing_${DateTime.now().millisecondsSinceEpoch}${p.extension(x.path)}"));
      await file.copy(saveAs.path);
      setState(() => photoFile = saveAs);
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Camera/Gallery permission needed")));
    }
  }

  Future<void> _callHelpline() async {
    final uri = Uri.parse("tel:+91112");
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot open dialer")));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => sending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => sending = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Report sent to Rescue Team ✅")));
    Navigator.pop(context);
  }

  Widget _sectionTitle(String title, {IconData? icon}) => Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 10),
    child: Row(children: [
      if (icon != null)
        Container(decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8), child: Icon(icon, color: Colors.deepOrange)),
      if (icon != null) const SizedBox(width: 10),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16.5, letterSpacing: .3)),
    ]),
  );

  Widget _card(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10, offset: const Offset(0, 6))]),
    padding: const EdgeInsets.all(14), child: child,
  );

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange;
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("Report Missing Person"),
        backgroundColor: orange,
        actions: [ IconButton(tooltip: "Emergency Helpline (112)", onPressed: _callHelpline, icon: const Icon(Icons.call)) ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [orange, orange.withOpacity(.8)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(14),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.campaign, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(child: Text(
                      "Maintain calm in the crowd. Fill in the details accurately — it will help the rescue team locate quickly.",
                      style: TextStyle(color: Colors.white, height: 1.3, fontWeight: FontWeight.w600),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              _card(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Person Details", icon: Icons.person),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.orange.shade100,
                        backgroundImage: photoFile != null ? FileImage(photoFile!) : null,
                        child: photoFile == null ? const Icon(Icons.person, size: 40, color: Colors.deepOrange) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Wrap(
                          spacing: 8, runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(foregroundColor: orange, side: BorderSide(color: orange)),
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.photo_camera), label: const Text("Camera"),
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(foregroundColor: orange, side: BorderSide(color: orange)),
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library), label: const Text("Gallery"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameC,
                    decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.badge_outlined), filled: true),
                    validator: (v) => (v == null || v.trim().isEmpty) ? "Enter name" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ageC,
                    decoration: const InputDecoration(labelText: "Age", prefixIcon: Icon(Icons.calendar_month), filled: true),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Enter age";
                      final n = int.tryParse(v);
                      if (n == null || n <= 0 || n > 120) return "Enter valid age";
                      return null;
                    },
                  ),
                ],
              )),

              _card(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Contact & Last Seen", icon: Icons.place),
                  TextFormField(
                    controller: guardianPhoneC, maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: "Family Contact Number", prefixText: "+91 ", counterText: "",
                      prefixIcon: Icon(Icons.phone), filled: true,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Enter contact number";
                      if (v.trim().length != 10) return "Enter 10-digit number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: lastSeenAt,
                    items: lastSeenOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => lastSeenAt = v),
                    decoration: const InputDecoration(labelText: "Last Seen At", prefixIcon: Icon(Icons.route), filled: true),
                    validator: (v) => v == null ? "Select last seen location" : null,
                  ),
                ],
              )),

              _card(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Appearance", icon: Icons.checkroom),
                  TextFormField(
                    controller: clothesC,
                    decoration: const InputDecoration(
                      labelText: "Clothes Description", hintText: "e.g., Blue T-shirt, black jeans, white shoes",
                      prefixIcon: Icon(Icons.checkroom), filled: true,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? "Enter clothes description" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descC, maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Identifying Marks / Details",
                      hintText: "e.g., Height ~5'7\", specs, wrist band, mole on right cheek",
                      prefixIcon: Icon(Icons.info_outline), filled: true,
                    ),
                  ),
                ],
              )),

              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                  ),
                  onPressed: sending ? null : _submit,
                  icon: sending
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                      : const Icon(Icons.send_rounded),
                  label: Text(sending ? "Sending..." : "Send to Rescue Team", style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: .2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
