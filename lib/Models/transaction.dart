class TransactionModel {
  int? id;
  String desc;
  String status;
  String dateTime;

  TransactionModel({
    this.id,
    required this.desc,
    required this.status,
    required this.dateTime,
  });

  // Convert from Map (for DB)
  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'],
        desc: json['desc'],
        status: json['status'],
        dateTime: json['dateTime'],
      );

  // Convert to Map (for DB)
  Map<String, dynamic> toMap() => {
        'id': id,
        'desc': desc,
        'status': status,
        'dateTime': dateTime,
      };
}
