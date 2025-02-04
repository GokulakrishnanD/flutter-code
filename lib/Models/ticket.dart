class Ticket {
  final String title;
  final String description;
  final String location;
  final String date;
  final String? attachmentUrl;
  final String id;
  final String status;
  final String createdBy;

  Ticket({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.attachmentUrl,
    this.id = '',
    required this.status,
    required this.createdBy,
  });

  factory Ticket.fromMap(Map<String, dynamic> map, [String id = '']) {
    return Ticket(
      id: id.isNotEmpty ? id : map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      date: map['date'],
      attachmentUrl: map['attachmentUrl'],
      status: map['status'],
      createdBy: map['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': date,
      'attachmentUrl': attachmentUrl,
      'status': status,
      'createdBy': createdBy,
    };
  }
}
