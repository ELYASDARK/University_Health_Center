/// Department model representing a health center department
class DepartmentModel {
  final String id;
  final String name;
  final String description;
  final List<String> services;
  final String? imageUrl;
  final bool isActive;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.services,
    this.imageUrl,
    this.isActive = true,
  });

  /// Create DepartmentModel from JSON
  factory DepartmentModel.fromJson(Map<String, dynamic> json, String id) {
    return DepartmentModel(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      services: List<String>.from(json['services'] ?? []),
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convert DepartmentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'services': services,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  DepartmentModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? services,
    String? imageUrl,
    bool? isActive,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      services: services ?? this.services,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}
