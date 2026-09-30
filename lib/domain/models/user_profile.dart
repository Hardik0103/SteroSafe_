import 'personal_baseline.dart';

class EmergencyContact {
  final String id;
  final String name;
  final String relationship;
  final String phone;
  final int priority; // 1 = highest

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relationship': relationship,
    'phone': phone,
    'priority': priority,
  };

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
    id: json['id'] as String,
    name: json['name'] as String,
    relationship: json['relationship'] as String,
    phone: json['phone'] as String,
    priority: json['priority'] as int? ?? 1,
  );
}

class UserProfile {
  final String fullName;
  final String phone;
  final int age;
  final String gender;
  final String bloodGroup;
  final double heightCm;
  final double weightKg;
  final LifestyleType lifestyle;
  final List<EmergencyContact> emergencyContacts;
  final List<String> healthConditions;
  final List<String> allergies;
  final List<String> currentMedications;
  final String doctorName;
  final String doctorPhone;
  final String doctorClinic;
  final bool sosCountdownEnabled;
  final bool autoShareLocation;
  final int dailyHydrationGoalMl;
  final String notes;

  const UserProfile({
    required this.fullName,
    required this.phone,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.heightCm,
    required this.weightKg,
    required this.lifestyle,
    required this.emergencyContacts,
    required this.healthConditions,
    required this.allergies,
    required this.currentMedications,
    required this.doctorName,
    required this.doctorPhone,
    required this.doctorClinic,
    this.sosCountdownEnabled = true,
    this.autoShareLocation = true,
    this.dailyHydrationGoalMl = 2500,
    this.notes = "",
  });

  factory UserProfile.defaultProfile() {
    return const UserProfile(
      fullName: "Hardik Vadukul",
      phone: "+91 98765 43210",
      age: 32,
      gender: "Male",
      bloodGroup: "B+",
      heightCm: 175.0,
      weightKg: 72.0,
      lifestyle: LifestyleType.construction,
      emergencyContacts: [
        EmergencyContact(
          id: "ec-1",
          name: "Dr. Ananya Sharma",
          relationship: "Physician / Family",
          phone: "+91 98220 12345",
          priority: 1,
        ),
        EmergencyContact(
          id: "ec-2",
          name: "Ramesh Vadukul",
          relationship: "Brother",
          phone: "+91 98111 54321",
          priority: 2,
        ),
      ],
      healthConditions: ["Heat sensitivity", "Mild Asthmatic Tendency"],
      allergies: ["Penicillin", "Dust / PM2.5"],
      currentMedications: ["Salbutamol Inhaler (PRN)", "Electrolyte supplement"],
      doctorName: "Dr. Arvind Patel",
      doctorPhone: "+91 94250 88990",
      doctorClinic: "Apollo Emergency & Pulmonary Care",
      sosCountdownEnabled: true,
      autoShareLocation: true,
      dailyHydrationGoalMl: 2500,
      notes: "Works outdoors during daytime heat spikes. Requires rigorous hydration alerts.",
    );
  }

  UserProfile copyWith({
    String? fullName,
    String? phone,
    int? age,
    String? gender,
    String? bloodGroup,
    double? heightCm,
    double? weightKg,
    LifestyleType? lifestyle,
    List<EmergencyContact>? emergencyContacts,
    List<String>? healthConditions,
    List<String>? allergies,
    List<String>? currentMedications,
    String? doctorName,
    String? doctorPhone,
    String? doctorClinic,
    bool? sosCountdownEnabled,
    bool? autoShareLocation,
    int? dailyHydrationGoalMl,
    String? notes,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      lifestyle: lifestyle ?? this.lifestyle,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      healthConditions: healthConditions ?? this.healthConditions,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      doctorName: doctorName ?? this.doctorName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      doctorClinic: doctorClinic ?? this.doctorClinic,
      sosCountdownEnabled: sosCountdownEnabled ?? this.sosCountdownEnabled,
      autoShareLocation: autoShareLocation ?? this.autoShareLocation,
      dailyHydrationGoalMl: dailyHydrationGoalMl ?? this.dailyHydrationGoalMl,
      notes: notes ?? this.notes,
    );
  }
}
