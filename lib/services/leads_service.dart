import '../constants/api_constants.dart';
import '../models/leads_response.dart';
import '../services/api_service.dart';

class LeadsService {
  LeadsService._();
  static const LeadsService instance = LeadsService._();

  Future<LeadsResponse> getMyLeads() async {
    try {
      final response = await ApiService.instance.dio.get(ApiConstants.leads);
      return LeadsResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiService.extractErrorMessage(e);
    }
  }
}
