import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/shimmer_card.dart';
import '../../core/widgets/state_views.dart';
import '../../providers/auth_provider.dart';
import '../../providers/leads_provider.dart';
import 'widgets/lead_card.dart';
import 'widgets/leads_filter_bar.dart';
import 'widgets/leads_summary_card.dart';

class LeadsScreen extends ConsumerStatefulWidget {
  const LeadsScreen({super.key});

  @override
  ConsumerState<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends ConsumerState<LeadsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leadsProvider.notifier).fetchLeads();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leadsState = ref.watch(leadsProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, authState, leadsState),
      body: RefreshIndicator(
        color: AppColors.primary,
        strokeWidth: 2.5,
        onRefresh: () => ref.read(leadsProvider.notifier).fetchLeads(),
        child: _buildBody(leadsState),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AuthState authState,
    LeadsState leadsState,
  ) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Leads', style: AppTextStyles.headlineMedium),
          if (authState.user?.email != null)
            Text(
              authState.user!.email,
              style: AppTextStyles.caption,
            ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 22),
          onPressed: leadsState.isLoading
              ? null
              : () => ref.read(leadsProvider.notifier).fetchLeads(),
          color: AppColors.textSecondary,
        ),
        _UserMenuButton(
          userInitial: authState.user?.name?.isNotEmpty == true
              ? authState.user!.name![0].toUpperCase()
              : (authState.user?.email.isNotEmpty == true
                  ? authState.user!.email[0].toUpperCase()
                  : '?'),
          onSignOut: () async {
            await ref.read(authProvider.notifier).signOut();
            if (mounted) context.go('/signin');
          },
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildBody(LeadsState leadsState) {
    if (leadsState.isLoading && leadsState.data == null) {
      return _LoadingState();
    }

    if (leadsState.error != null && leadsState.data == null) {
      return ErrorView(
        message: leadsState.error!,
        onRetry: () => ref.read(leadsProvider.notifier).fetchLeads(),
      );
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Summary card
        SliverToBoxAdapter(
          child: leadsState.data != null
              ? LeadsSummaryCard(
                  count: leadsState.data!.count,
                  website: leadsState.data!.website,
                  hostname: leadsState.data!.hostname,
                )
              : const ShimmerSummaryCard(),
        ),
        // Filter bar
        SliverToBoxAdapter(
          child: LeadsFilterBar(
            searchQuery: leadsState.searchQuery,
            activeStatus: leadsState.statusFilter,
            sortOrder: leadsState.sortOrder,
            onSearchChanged: ref.read(leadsProvider.notifier).setSearch,
            onStatusChanged: ref.read(leadsProvider.notifier).setStatusFilter,
            onSortChanged: ref.read(leadsProvider.notifier).setSortOrder,
          ),
        ),
        // Results count
        if (leadsState.data != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                AppSpacing.md,
                AppSpacing.base,
                AppSpacing.sm,
              ),
              child: Text(
                '${leadsState.filteredLeads.length} '
                '${leadsState.filteredLeads.length == 1 ? 'lead' : 'leads'}',
                style: AppTextStyles.labelMedium,
              ),
            ),
          ),
        // Lead list or empty state
        if (leadsState.data != null && leadsState.filteredLeads.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              icon: Icons.person_search_rounded,
              title: leadsState.searchQuery.isNotEmpty || leadsState.statusFilter != null
                  ? 'No leads match your filters'
                  : 'No leads yet',
              subtitle: leadsState.searchQuery.isNotEmpty || leadsState.statusFilter != null
                  ? 'Try adjusting your search or filter criteria.'
                  : 'Leads from your website will appear here.',
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final leads = leadsState.filteredLeads;
                if (index >= leads.length) return null;
                return LeadCard(lead: leads[index], index: index);
              },
              childCount: leadsState.filteredLeads.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const ShimmerSummaryCard(),
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: Column(
              children: List.generate(
                5,
                (i) => const ShimmerLeadCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMenuButton extends StatelessWidget {
  final String userInitial;
  final VoidCallback onSignOut;

  const _UserMenuButton({
    required this.userInitial,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'signout') onSignOut();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 4,
      color: AppColors.surface,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            userInitial,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'signout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Sign Out',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
