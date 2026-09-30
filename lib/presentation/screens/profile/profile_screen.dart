import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/personal_baseline.dart';
import '../../../domain/models/user_profile.dart';
import '../../providers/app_state.dart';

class ProfileScreen extends StatefulWidget {
  final AppState state;

  const ProfileScreen({super.key, required this.state});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _doctorNameController;
  late TextEditingController _doctorPhoneController;
  late TextEditingController _doctorClinicController;
  late TextEditingController _hydrationGoalController;
  late LifestyleType _selectedLifestyle;

  @override
  void initState() {
    super.initState();
    final p = widget.state.profile;
    _nameController = TextEditingController(text: p.fullName);
    _phoneController = TextEditingController(text: p.phone);
    _ageController = TextEditingController(text: "${p.age}");
    _doctorNameController = TextEditingController(text: p.doctorName);
    _doctorPhoneController = TextEditingController(text: p.doctorPhone);
    _doctorClinicController = TextEditingController(text: p.doctorClinic);
    _hydrationGoalController = TextEditingController(text: "${p.dailyHydrationGoalMl}");
    _selectedLifestyle = p.lifestyle;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _doctorNameController.dispose();
    _doctorPhoneController.dispose();
    _doctorClinicController.dispose();
    _hydrationGoalController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updated = widget.state.profile.copyWith(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? widget.state.profile.age,
      lifestyle: _selectedLifestyle,
      doctorName: _doctorNameController.text.trim(),
      doctorPhone: _doctorPhoneController.text.trim(),
      doctorClinic: _doctorClinicController.text.trim(),
      dailyHydrationGoalMl: int.tryParse(_hydrationGoalController.text.trim()) ?? 2500,
    );
    widget.state.updateProfile(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile saved securely to Qualcomm on-device storage"),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _showAddContactDialog() {
    final nameCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Emergency Contact", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: relationCtrl, decoration: const InputDecoration(labelText: "Relationship (e.g. Spouse, Brother)")),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Phone Number (+91...)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                final newContact = EmergencyContact(
                  id: "ec-${DateTime.now().millisecondsSinceEpoch}",
                  name: nameCtrl.text.trim(),
                  relationship: relationCtrl.text.trim().isEmpty ? "Family" : relationCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  priority: widget.state.profile.emergencyContacts.length + 1,
                );
                final updatedContacts = List<EmergencyContact>.from(widget.state.profile.emergencyContacts)..add(newContact);
                widget.state.updateProfile(widget.state.profile.copyWith(emergencyContacts: updatedContacts));
                Navigator.pop(ctx);
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
            child: const Text("Add Contact"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.state.profile;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "Personal & Medical Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppTheme.primaryBlue),
            onPressed: _saveProfile,
            tooltip: "Save Profile",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar & Name banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryLightBlue,
                    child: Text(
                      profile.fullName.isNotEmpty ? profile.fullName[0] : "U",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.phone,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildMiniChip("${profile.age} yrs"),
                            const SizedBox(width: 6),
                            _buildMiniChip(profile.bloodGroup),
                            const SizedBox(width: 6),
                            _buildMiniChip("${profile.weightKg} kg"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lifestyle / Occupation Picker
            _buildSectionHeader("Lifestyle & Baseline Setting", Icons.fitness_center_rounded),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Occupation / Daily Activity Profile",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<LifestyleType>(
                    initialValue: _selectedLifestyle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: LifestyleType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedLifestyle = val);
                        widget.state.updateProfile(widget.state.profile.copyWith(lifestyle: val));
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.state.baseline.lifestyleDescription,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Contacts
            _buildSectionHeader("Emergency Contacts (Priority SOS)", Icons.contact_phone_rounded, onAdd: _showAddContactDialog),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: profile.emergencyContacts.map((contact) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSubtle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppTheme.dangerLightRed,
                              child: Text("${contact.priority}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.dangerRed)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contact.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                Text("${contact.relationship} • ${contact.phone}", style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.dangerRed),
                          onPressed: () {
                            final updated = List<EmergencyContact>.from(profile.emergencyContacts)..removeWhere((c) => c.id == contact.id);
                            widget.state.updateProfile(profile.copyWith(emergencyContacts: updated));
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Medical Info & Allergies
            _buildSectionHeader("Medical Conditions & Allergies", Icons.medical_services_outlined),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Known Medical Conditions:", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: profile.healthConditions.map((c) => _buildBadge(c, AppTheme.primaryLightBlue, AppTheme.primaryBlue)).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text("Allergies (Transmitted with SOS):", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: profile.allergies.map((a) => _buildBadge(a, AppTheme.dangerLightRed, AppTheme.dangerRed)).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text("Current Medications:", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: profile.currentMedications.map((m) => _buildBadge(m, const Color(0xFFFEF3C7), const Color(0xFFB45309))).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Doctor Information
            _buildSectionHeader("Doctor & Clinic Information", Icons.local_hospital_rounded),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _doctorNameController,
                    decoration: const InputDecoration(labelText: "Doctor's Name", isDense: true),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _doctorPhoneController,
                    decoration: const InputDecoration(labelText: "Doctor's Phone", isDense: true),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _doctorClinicController,
                    decoration: const InputDecoration(labelText: "Hospital / Clinic", isDense: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Save Changes", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {VoidCallback? onAdd}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          ),
          if (onAdd != null)
            InkWell(
              onTap: onAdd,
              child: const Text("+ Add", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSubtle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
    );
  }

  Widget _buildBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: text)),
    );
  }
}
