import 'package:equatable/equatable.dart';

/// Model for learning resources (platforms, books, tools, competitions)
class ResourceModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category; // 'problem_solving', 'books', 'tools', 'competitions'
  final bool isFree;
  final String? url; // Optional URL for the resource
  final String? author; // For books

  const ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isFree = true,
    this.url,
    this.author,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    isFree,
    url,
    author,
  ];

  ResourceModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isFree,
    String? url,
    String? author,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isFree: isFree ?? this.isFree,
      url: url ?? this.url,
      author: author ?? this.author,
    );
  }
}
