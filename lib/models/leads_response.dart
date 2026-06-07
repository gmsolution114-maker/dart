import 'lead.dart';

class LeadsResponse {
  final String website;
  final String hostname;
  final int count;
  final List<Lead> leads;

  const LeadsResponse({
    required this.website,
    required this.hostname,
    required this.count,
    required this.leads,
  });

  factory LeadsResponse.fromJson(Map<String, dynamic> json) {
    final rawLeads = json['leads'];
    final leadList = rawLeads is List
        ? rawLeads.whereType<Map<String, dynamic>>().map(Lead.fromJson).toList()
        : <Lead>[];

    return LeadsResponse(
      website: json['website']?.toString() ?? '',
      hostname: json['hostname']?.toString() ?? '',
      count: json['count'] is int ? json['count'] as int : int.tryParse(json['count']?.toString() ?? '') ?? 0,
      leads: leadList,
    );
  }
}
