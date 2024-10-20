class AppUser {
  final String uid;
  final String name;
  final String email;

  AppUser({required this.uid, required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory AppUser.formJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      name: jsonUser['name'],
      email: jsonUser['email'],
    );
  }
}
