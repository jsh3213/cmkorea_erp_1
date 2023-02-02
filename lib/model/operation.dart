// ignore_for_file: prefer_typing_uninitialized_variables

class Operation {
  int id;
  String place;
  String note;
  String stateNote;
  String requester;
  String completer;
  var created;
  var updated;
  var doneDate;
  String state;

  Operation({
    required this.id,
    required this.place,
    required this.note,
    required this.stateNote,
    required this.requester,
    required this.completer,
    required this.created,
    required this.updated,
    required this.doneDate,
    required this.state,
  });

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      id: json['id'] ?? '',
      place: json['place'] ?? '',
      note: json['note'] ?? '',
      stateNote: json['stateNote'] ?? '',
      requester: json['requester'] ?? '',
      completer: json['completer'] ?? '',
      created: json['created'] ?? '',
      updated: json['updated'] ?? '',
      doneDate: json['doneDate'] ?? '',
      state: json['state'] ?? '선택',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place,
      'note': note,
      'stateNote': stateNote,
      'requester': requester,
      'completer': completer,
      'created': created,
      'updated': updated,
      'doneDate': doneDate,
      'state': state,
    };
  }
}
