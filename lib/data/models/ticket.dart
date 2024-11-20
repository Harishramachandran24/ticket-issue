class Ticket {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String attachmentUrl;
  final bool isSynced; 

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.attachmentUrl,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'attachmentUrl': attachmentUrl,
      'isSynced': isSynced ? 1 : 0, 
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      date: DateTime.parse(map['date']),
      attachmentUrl: map['attachmentUrl'],
      isSynced: map['isSynced'] == 1,
    );
  }
}
