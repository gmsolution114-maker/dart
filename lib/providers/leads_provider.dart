import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lead.dart';
import '../models/leads_response.dart';
import '../services/leads_service.dart';

enum SortOrder { newestFirst, oldestFirst, mostClicks }

class LeadsState {
  final LeadsResponse? data;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? statusFilter;
  final SortOrder sortOrder;

  const LeadsState({
    this.data,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.statusFilter,
    this.sortOrder = SortOrder.newestFirst,
  });

  LeadsState copyWith({
    LeadsResponse? data,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? searchQuery,
    String? statusFilter,
    bool clearStatusFilter = false,
    SortOrder? sortOrder,
  }) {
    return LeadsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  List<Lead> get filteredLeads {
    if (data == null) return [];

    var leads = data!.leads.toList();

    // Apply status filter
    if (statusFilter != null && statusFilter!.isNotEmpty) {
      leads = leads
          .where((l) => l.displayStatus.toLowerCase() == statusFilter!.toLowerCase())
          .toList();
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      leads = leads.where((l) {
        return (l.fullName?.toLowerCase().contains(q) ?? false) ||
            (l.email?.toLowerCase().contains(q) ?? false) ||
            (l.city?.toLowerCase().contains(q) ?? false) ||
            (l.phoneNumber?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    // Apply sort
    switch (sortOrder) {
      case SortOrder.newestFirst:
        leads.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
      case SortOrder.oldestFirst:
        leads.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return a.createdAt!.compareTo(b.createdAt!);
        });
      case SortOrder.mostClicks:
        leads.sort((a, b) => (b.clicks ?? 0).compareTo(a.clicks ?? 0));
    }

    return leads;
  }
}

class LeadsNotifier extends StateNotifier<LeadsState> {
  LeadsNotifier() : super(const LeadsState());

  Future<void> fetchLeads() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await LeadsService.instance.getMyLeads();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(String? status) {
    if (status == null || status == state.statusFilter) {
      state = state.copyWith(clearStatusFilter: true);
    } else {
      state = state.copyWith(statusFilter: status);
    }
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final leadsProvider = StateNotifierProvider<LeadsNotifier, LeadsState>(
  (_) => LeadsNotifier(),
);
