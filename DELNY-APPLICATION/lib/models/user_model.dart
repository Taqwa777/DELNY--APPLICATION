class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? career;
  final String? location;
  final String? experience;
  final bool isServiceProvider;
  final List<String> favorites;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.career,
    this.location,
    this.experience,
    required this.isServiceProvider,
    this.favorites = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      career: map['career'],
      location: map['location'],
      experience: map['experience'],
      isServiceProvider: map['isServiceProvider'] ?? false,
      favorites: List<String>.from(map['favorites'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'career': career,
      'location': location,
      'experience': experience,
      'isServiceProvider': isServiceProvider,
      'favorites': favorites,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? career,
    String? location,
    String? experience,
    bool? isServiceProvider,
    List<String>? favorites,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      career: career ?? this.career,
      location: location ?? this.location,
      experience: experience ?? this.experience,
      isServiceProvider: isServiceProvider ?? this.isServiceProvider,
      favorites: favorites ?? this.favorites,
    );
  }
}