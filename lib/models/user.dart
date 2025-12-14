class User {
  final int id;
  final String name;
  final String? bio;
  final String? address;
  final String? photo;
  final int? tokoId;

  User({
    required this.id,
    required this.name,
    this.bio,
    this.address,
    this.photo,
    this.tokoId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      address: json['address'],
      photo: json['photo'],
      tokoId: json['store_id'], // ⬅️ FIX
    );
  }
}
