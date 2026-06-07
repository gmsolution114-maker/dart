class Lead {
  final String id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? city;
  final String? comment;
  final String? website;
  final String? question;
  final String? answer;
  final int? clicks;
  final DateTime? createdAt;
  final String? status;
  final int? passengers;
  final DateTime? dateOfService;

  const Lead({
    required this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.address,
    this.city,
    this.comment,
    this.website,
    this.question,
    this.answer,
    this.clicks,
    this.createdAt,
    this.status,
    this.passengers,
    this.dateOfService,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      fullName: json['fullName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      comment: json['comment']?.toString(),
      website: json['website']?.toString(),
      question: json['question']?.toString(),
      answer: json['answer']?.toString(),
      clicks: json['clicks'] is int ? json['clicks'] as int : int.tryParse(json['clicks']?.toString() ?? ''),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      status: json['status']?.toString(),
      passengers: json['passengers'] is int
          ? json['passengers'] as int
          : int.tryParse(json['passengers']?.toString() ?? ''),
      dateOfService: json['dateOfService'] != null
          ? DateTime.tryParse(json['dateOfService'].toString())
          : null,
    );
  }

  String get displayName => (fullName?.isNotEmpty == true) ? fullName! : 'Unknown Lead';
  String get displayStatus => status?.isNotEmpty == true ? status! : 'new';
}
