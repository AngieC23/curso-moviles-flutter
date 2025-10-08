class Joke {
  final String iconUrl;
  final String id;
  final String url;
  final String value;
  final List<String>? categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Joke({
    required this.iconUrl,
    required this.id,
    required this.url,
    required this.value,
    this.categories,
    this.createdAt,
    this.updatedAt,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      iconUrl: json['icon_url'] ?? '',
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      value: json['value'] ?? '',
      categories: json['categories'] != null 
          ? List<String>.from(json['categories']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon_url': iconUrl,
      'id': id,
      'url': url,
      'value': value,
      'categories': categories,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Joke{id: $id, value: ${value.substring(0, value.length > 50 ? 50 : value.length)}...}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Joke && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}