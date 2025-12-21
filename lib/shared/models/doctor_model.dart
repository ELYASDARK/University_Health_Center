/// Doctor model representing a medical practitioner
class DoctorModel {
  final String id;
  final String userId;
  final String specialization;
  final String departmentId;
  final Map<String, dynamic> availability;
  final double rating;
  final String bio;
  final String? imageUrl;
  final String? name; // Doctor's full name for display
  final String? email;

  DoctorModel({
    required this.id,
    required this.userId,
    required this.specialization,
    required this.departmentId,
    required this.availability,
    this.rating = 0.0,
    required this.bio,
    this.imageUrl,
    this.name,
    this.email,
  });

  /// Check if doctor is available on a specific day
  bool isAvailableOn(String day) {
    return availability.containsKey(day) && availability[day] == true;
  }

  /// Create DoctorModel from JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json, String id) {
    return DoctorModel(
      id: id,
      userId: json['userId'] as String,
      specialization: json['specialization'] as String,
      departmentId: json['departmentId'] as String,
      availability: json['availability'] as Map<String, dynamic>? ?? {},
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      bio: json['bio'] as String,
      imageUrl: json['imageUrl'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );
  }

  /// Convert DoctorModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'specialization': specialization,
      'departmentId': departmentId,
      'availability': availability,
      'rating': rating,
      'bio': bio,
      'imageUrl': imageUrl,
      'name': name,
      'email': email,
    };
  }

  /// Create a copy with updated fields
  DoctorModel copyWith({
    String? id,
    String? userId,
    String? specialization,
    String? departmentId,
    Map<String, dynamic>? availability,
    double? rating,
    String? bio,
    String? imageUrl,
    String? name,
    String? email,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      specialization: specialization ?? this.specialization,
      departmentId: departmentId ?? this.departmentId,
      availability: availability ?? this.availability,
      rating: rating ?? this.rating,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
