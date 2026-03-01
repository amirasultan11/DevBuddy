import 'package:equatable/equatable.dart';

/// Model for community tips and advice
/// Used in "Amira's Picks" section
class TipModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String author;
  final String? category; // Optional: e.g., "Motivation", "Technical", "Career"

  const TipModel({
    required this.id,
    required this.title,
    required this.content,
    this.author = 'Amira Abdelsalam',
    this.category,
  });

  @override
  List<Object?> get props => [id, title, content, author, category];

  TipModel copyWith({
    String? id,
    String? title,
    String? content,
    String? author,
    String? category,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      category: category ?? this.category,
    );
  }
}
