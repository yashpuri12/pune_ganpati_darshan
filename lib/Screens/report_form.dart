// lib/screens/report_form.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});

  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _ageC = TextEditingController();
  final _contactC = TextEditingController();
  final _lastSeenC = TextEditingController();
  final _aadhaarC = TextEditingController();
  final _idNoC = TextEditingController();
  final _notesC = TextEditingController();

  String _gender = 'Male';
  String _idType = 'Aadhaar';
  DateTime? _lastSeenDateTime;
  File? _photo;
  final _picker = ImagePicker();

  Future<void> _pickPhoto(ImageSource src) async {
    final x = await _picker.pickImage(source: src, imageQuality: 70);
    if (x == null) return;
    setState(() => _photo = File(x.path));
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _lastSeenDateTime ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (d == null) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));
    if (t == null) return;
    setState(() => _lastSeenDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  bool _validateAadhaar(String v) {
    final s = v.replaceAll(RegExp(r'\s+'), '');
    return RegExp(r'^[2-9]\d{11}$').hasMatch(s);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "name": _nameC.text.trim(),
      "age": _ageC.text.trim(),
      "gender": _gender,
      "contact": _contactC.text.trim(),
      "lastSeen": _lastSeenC.text.trim(),
      "lastSeenAt": _lastSeenDateTime?.toIso8601String() ?? '',
      "aadhaar": _aadhaarC.text.trim(),
      "idType": _idType,
      "idNumber": _idNoC.text.trim(),
      "notes": _notesC.text.trim(),
      "photoPath": _photo?.path ?? '',
      "reportedAt": DateTime.now().toIso8601String(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report submitted — team will contact you soon.")),
    );

    // debug print
    // ignore: avoid_print
    print("Missing person report submitted: $data");

    Navigator.pop(context, data);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _ageC.dispose();
    _contactC.dispose();
    _lastSeenC.dispose();
    _aadhaarC.dispose();
    _idNoC.dispose();
    _notesC.dispose();
    super.dispose();
  }

  InputDecoration _inputDecor({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange;
    final mq = MediaQuery.of(context);
    final avatarSize = (mq.size.width * 0.14).clamp(44.0, 68.0);
    final bottomInset = mq.viewInsets.bottom;

    // DEBUG: uncomment if you want to see actual width in console
    // print('SCREEN WIDTH: ${mq.size.width}');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Missing Person"),
        backgroundColor: orange,
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 18, 16, 18 + bottomInset),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // PHOTO ROW
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10)],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          shape: BoxShape.circle,
                          image: _photo != null ? DecorationImage(image: FileImage(_photo!), fit: BoxFit.cover) : null,
                        ),
                        child: _photo == null
                            ? Icon(Icons.person_search, size: avatarSize * 0.55, color: orange)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _pickPhoto(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text("Camera"),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _pickPhoto(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text("Gallery"),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              ),
                            ),
                            if (_photo != null)
                              TextButton.icon(
                                onPressed: () => setState(() => _photo = null),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text("Remove"),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // MAIN CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full name
                      TextFormField(
                        controller: _nameC,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecor(label: "Full name", icon: Icons.person),
                        validator: (v) => (v ?? '').trim().isEmpty ? "Please enter name" : null,
                      ),
                      const SizedBox(height: 12),

                      // Age + Gender using Row + Expanded (prevents overflow)
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _ageC,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecor(label: "Age", icon: Icons.calendar_today),
                              validator: (v) {
                                final s = (v ?? '').trim();
                                if (s.isEmpty) return "Enter age";
                                if (int.tryParse(s) == null) return "Invalid age";
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              isExpanded: true,
                              decoration: _inputDecor(label: "Gender", icon: Icons.transgender),
                              items: const [
                                DropdownMenuItem(value: "Male", child: Text("Male")),
                                DropdownMenuItem(value: "Female", child: Text("Female")),
                                DropdownMenuItem(value: "Other", child: Text("Other")),
                              ],
                              onChanged: (v) => setState(() => _gender = v ?? "Male"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Contact
                      TextFormField(
                        controller: _contactC,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecor(label: "Contact number (for family)", icon: Icons.phone),
                        validator: (v) {
                          final s = (v ?? '').trim();
                          if (s.isEmpty) return "Enter contact";
                          if (!RegExp(r'^\+?\d{7,15}$').hasMatch(s)) return "Invalid phone";
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Last seen place
                      TextFormField(
                        controller: _lastSeenC,
                        decoration: _inputDecor(label: "Last seen (place/area)", icon: Icons.place),
                        validator: (v) => (v ?? '').trim().isEmpty ? "Enter last seen place" : null,
                      ),

                      const SizedBox(height: 12),

                      // Date/time picker button
                      OutlinedButton.icon(
                        onPressed: _pickDateTime,
                        icon: const Icon(Icons.access_time_outlined),
                        label: Text(_lastSeenDateTime == null
                            ? "Pick date & time"
                            : "${_lastSeenDateTime!.day}/${_lastSeenDateTime!.month}/${_lastSeenDateTime!.year} ${_lastSeenDateTime!.hour.toString().padLeft(2, '0')}:${_lastSeenDateTime!.minute.toString().padLeft(2, '0')}"),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade200),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Aadhaar field (optional)
                      TextFormField(
                        controller: _aadhaarC,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecor(label: "Aadhaar number (optional)", icon: Icons.credit_card),
                        validator: (v) {
                          final s = (v ?? '').trim();
                          if (s.isEmpty) return null;
                          if (!_validateAadhaar(s)) return "Invalid Aadhaar";
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // ID Type + ID Number: responsive Row with Expanded
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: _idType,
                              isExpanded: true,
                              decoration: _inputDecor(label: "ID Type", icon: Icons.badge_outlined),
                              items: const [
                                DropdownMenuItem(value: "Aadhaar", child: Text("Aadhaar")),
                                DropdownMenuItem(value: "Voter ID", child: Text("Voter ID")),
                                DropdownMenuItem(value: "Driving License", child: Text("Driving License")),
                                DropdownMenuItem(value: "Passport", child: Text("Passport")),
                                DropdownMenuItem(value: "Other", child: Text("Other")),
                              ],
                              onChanged: (v) => setState(() => _idType = v ?? "Aadhaar"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _idNoC,
                              decoration: _inputDecor(label: "ID number", icon: Icons.description_outlined),
                              validator: (v) {
                                final s = (v ?? '').trim();
                                if (s.isEmpty) return null;
                                if (s.length < 3) return "Too short";
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Additional notes
                      TextFormField(
                        controller: _notesC,
                        maxLines: 4,
                        decoration: _inputDecor(label: "Additional details / identification marks", icon: Icons.note_outlined),
                      ),

                      const SizedBox(height: 16),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.send_rounded),
                          label: const Text("Submit Report", style: TextStyle(fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text("Provide accurate details — team will contact you soon.", style: TextStyle(color: Colors.grey.shade700), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}