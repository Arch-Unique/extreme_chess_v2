class User {
  String firstName, lastName, email, image, id;

  User(
      {this.firstName = "",
      this.lastName = "",
      this.image = "",
      this.id = "",
      this.email = ""});

  String get fullName => "$firstName $lastName";

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? "Fisayo",
      lastName: json['lastName'] ?? "Fosudo",
      image: json['image'] ?? "",
      id: json['id'] ?? "",
      email: json['email'] ?? "fisayofosudo@gmail.com",
    );
  }
}
