class PlayerPost {
  String playerimage, description, description2, description3, description4, description5, date, time;
  String playerpostKey;
  PlayerPost(this.playerimage, this.description, this.description2,
      this.description3, this.description4, this.description5, this.date, this.time, this.playerpostKey);

  toJson() {
    return {
      'picture': playerimage,
      'description': description,
      'description2': description2,
      'description3': description3,
      'description4': description4,
      'description5': description5,
      'date': date,
      'time': time,
    };
  }
}
