class User {
  String username, email, image, id;
  int elo, wins, draws, losses;

  User(
      {this.username = "",
      this.image = "",
      this.id = "",
      this.elo = 0,
      this.wins = 0,
      this.draws = 0,
      this.losses = 0,
      this.email = ""});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? "ExtremePlayer",
      image: json['user_image'] ?? "",
      id: json['id'] ?? "",
      elo: json['elo'] ?? 0,
      wins: json['wins'] ?? 0,
      draws: json['draws'] ?? 0,
      losses: json['losses'] ?? 0,
      email: json['email'] ?? "",
    );
  }

  factory User.fromColorJson(Map<String, dynamic> json, String color) {
    return User(
      username: json['$color.username'] ?? "ExtremePlayer",
      image: json['$color.user_image'] ?? "",
      id: json['$color.id'] ?? "",
      elo: json['$color.elo'] ?? 0,
      wins: json['$color.wins'] ?? 0,
      draws: json['$color.draws'] ?? 0,
      losses: json['$color.losses'] ?? 0,
      email: json['$color.email'] ?? "",
    );
  }
}

class AvailableUser extends User {
  bool isAvailable;

  AvailableUser({
    super.username,
    super.image,
    super.id,
    super.elo,
    this.isAvailable = false,
  });

  factory AvailableUser.fromJson(Map<String, dynamic> json) {
    return AvailableUser(
        username: json['username'] ?? "ExtremePlayer",
        image: json['image'] ?? "",
        id: json['id'] ?? "",
        elo: json['elo'] ?? 0,
        isAvailable: json['isFree'] ?? false);
  }
}

class Contributor extends User {
  String url;

  Contributor({
    super.username,
    this.url = "",
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      username: json['username'] ?? "ExtremePlayer",
      url: json['url'] ?? "",
    );
  }
}
