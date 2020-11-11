class EventPost {
  String eventimage, description, date, time;
  String eventpostKey;
  EventPost(this.eventimage, this.description, this.date, this.time, this.eventpostKey);

  toJson() {
    return {
      'picture': eventimage,
      'description': description,
      'date': date,
      'time': time,
    };
  }
}
