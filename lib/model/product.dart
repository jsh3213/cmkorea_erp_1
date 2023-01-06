// ignore_for_file: prefer_typing_uninitialized_variables

class Product {
  int id;
  String serialNumber;
  String model;
  String note;
  var created;
  var updated;
  String line;
  String manager;
  String standard;
  String ir;
  String receivingDay;
  bool erpUploadIn;
  bool erpUploadOut;
  String barCode;
  bool repairDone;
  String repairTypeDecide;
  List<InImage> inImage;
  List<OutImage> outImage;

  Product({
    required this.id,
    required this.serialNumber,
    required this.model,
    required this.note,
    required this.created,
    required this.updated,
    required this.line,
    required this.manager,
    required this.standard,
    required this.inImage,
    required this.outImage,
    required this.ir,
    required this.receivingDay,
    required this.erpUploadIn,
    required this.erpUploadOut,
    required this.barCode,
    required this.repairDone,
    required this.repairTypeDecide,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      model: json['model'] ?? '',
      note: json['note'] ?? '',
      created: json['created'] ?? '',
      updated: json['updated'] ?? '',
      line: json['line'] ?? '',
      manager: json['manager'] ?? '',
      standard: json['standard'] ?? '',
      ir: json['ir'] ?? '',
      receivingDay: json['receivingDay'] ?? '',
      erpUploadIn: json['erpUploadIn'] ?? false,
      erpUploadOut: json['erpUploadOut'] ?? false,
      barCode: json['barCode'] ?? '',
      repairDone: json['repairDone'] ?? false,
      repairTypeDecide: json['repairTypeDecide'] ?? '선택',
      inImage: ((json['inImages'] ?? []) as List)
          .map((map) => InImage.fromJson(map))
          .toList(),
      outImage: ((json['outImages'] ?? []) as List)
          .map((map) => OutImage.fromJson(map))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'model': model,
      'note': note,
      'created': created,
      'updated': updated,
      'line': line,
      'manager': manager,
      'standard': standard,
      'inImage': inImage,
      'ir': ir,
      'receivingDay': receivingDay,
      'erpUploadIn': erpUploadIn,
      'erpUploadOut': erpUploadOut,
      'barCode': barCode,
      'repairDone': repairDone,
      'repairTypeDecide': repairTypeDecide,
    };
  }
}

class InImage {
  var id;
  var image;

  InImage({required this.id, required this.image});

  factory InImage.fromJson(Map<String, dynamic> json) {
    return InImage(
      id: json['id'] ?? Null,
      image: json['image'] ?? Null,
    );
  }
}

class OutImage {
  var id;
  var image;

  OutImage({required this.id, required this.image});

  factory OutImage.fromJson(Map<String, dynamic> json) {
    return OutImage(
      id: json['id'] ?? Null,
      image: json['image'] ?? '',
    );
  }
}
