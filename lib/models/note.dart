class Note {
  int? id;
  late String name;
  late String date;
  late String note;
  late int position;

  Note(this.name, this.date, this.note, this.position);
  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    date = map['date'];
    note = map['note'];
    position = map['position'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'note': note,
      'position': position
    };
  }
}
