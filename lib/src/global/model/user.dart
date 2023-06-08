class User {
  String firstName, lastName, email, image, id;

  User(
      {this.firstName = "Fisayo",
      this.lastName = "Fosudo",
      this.image = "",
      this.id = "",
      this.email = "fisayofosudo@gmail.com"});

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
