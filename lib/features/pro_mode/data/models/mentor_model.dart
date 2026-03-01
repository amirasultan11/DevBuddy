import 'package:equatable/equatable.dart';

/// Model for mentors available for booking sessions
class MentorModel extends Equatable {
  final String id;
  final String name;
  final String title;
  final String company;
  final double rating; // 0.0 to 5.0
  final List<String> skills;
  final int hourlyRate; // In USD
  final String? badge; // e.g., "Top Mentor", "Ex-Google"
  final String avatarEmoji; // Emoji for avatar

  const MentorModel({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.rating,
    required this.skills,
    required this.hourlyRate,
    this.badge,
    this.avatarEmoji = '👨‍💻',
  });

  @override
  List<Object?> get props => [
    id,
    name,
    title,
    company,
    rating,
    skills,
    hourlyRate,
    badge,
    avatarEmoji,
  ];

  MentorModel copyWith({
    String? id,
    String? name,
    String? title,
    String? company,
    double? rating,
    List<String>? skills,
    int? hourlyRate,
    String? badge,
    String? avatarEmoji,
  }) {
    return MentorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      company: company ?? this.company,
      rating: rating ?? this.rating,
      skills: skills ?? this.skills,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      badge: badge ?? this.badge,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }
}
