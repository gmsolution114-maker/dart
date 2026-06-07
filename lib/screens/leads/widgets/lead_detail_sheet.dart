import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/lead.dart';
import 'leads_filter_bar.dart';

void showLeadDetailSheet(BuildContext context, Lead lead) {
  HapticFeedback.mediumImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => LeadDetailSheet(lead: lead),
  );
}

class LeadDetailSheet extends StatelessWidget {
  final Lead lead;
  const LeadDetailSheet({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final status = lead.displayStatus;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.x2l),
          topRight: Radius.circular(AppSpacing.x2l),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.base,
              AppSpacing.base,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lead.displayName, style: AppTextStyles.headlineLarge),
                      const SizedBox(height: AppSpacing.xs),
                      _StatusBadgeInline(status: status),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.borderLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          const Divider(height: 1),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Contact Information'),
                  const SizedBox(height: AppSpacing.md),
                  _DetailGrid(
                    items: [
                      _DetailItem(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        value: lead.email,
                      ),
                      _DetailItem(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: lead.phoneNumber,
                      ),
                      _DetailItem(
                        icon: Icons.location_on_outlined,
                        label: 'City',
                        value: lead.city,
                      ),
                      _DetailItem(
                        icon: Icons.home_outlined,
                        label: 'Address',
                        value: lead.address,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _SectionTitle('Lead Details'),
                  const SizedBox(height: AppSpacing.md),
                  _DetailGrid(
                    items: [
                      _DetailItem(
                        icon: Icons.schedule_rounded,
                        label: 'Created',
                        value: DateFormatter.formatWithTime(lead.createdAt),
                      ),
                      _DetailItem(
                        icon: Icons.touch_app_rounded,
                        label: 'Clicks',
                        value: lead.clicks?.toString(),
                      ),
                      _DetailItem(
                        icon: Icons.people_rounded,
                        label: 'Passengers',
                        value: lead.passengers?.toString(),
                      ),
                      _DetailItem(
                        icon: Icons.event_rounded,
                        label: 'Date of Service',
                        value: DateFormatter.format(lead.dateOfService),
                      ),
                    ],
                  ),
                  if (lead.question?.isNotEmpty == true || lead.answer?.isNotEmpty == true) ...[
                    const SizedBox(height: AppSpacing.xl),
                    _SectionTitle('Inquiry'),
                    const SizedBox(height: AppSpacing.md),
                    if (lead.question?.isNotEmpty == true)
                      _FullWidthDetail(
                        label: 'Question',
                        value: lead.question!,
                        icon: Icons.help_outline_rounded,
                      ),
                    if (lead.answer?.isNotEmpty == true) ...[
                      const SizedBox(height: AppSpacing.md),
                      _FullWidthDetail(
                        label: 'Answer',
                        value: lead.answer!,
                        icon: Icons.chat_bubble_outline_rounded,
                      ),
                    ],
                  ],
                  if (lead.comment?.isNotEmpty == true) ...[
                    const SizedBox(height: AppSpacing.xl),
                    _SectionTitle('Comment'),
                    const SizedBox(height: AppSpacing.md),
                    _FullWidthDetail(
                      label: 'Comment',
                      value: lead.comment!,
                      icon: Icons.notes_rounded,
                    ),
                  ],
                  SizedBox(height: mediaQuery.padding.bottom + AppSpacing.base),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textTertiary,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String? value;
  const _DetailItem({required this.icon, required this.label, this.value});
}

class _DetailGrid extends StatelessWidget {
  final List<_DetailItem> items;
  const _DetailGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final visible = items.where((i) => i.value?.isNotEmpty == true).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: visible
          .map(
            (item) => Container(
              constraints: BoxConstraints(
                minWidth: (MediaQuery.of(context).size.width - AppSpacing.xl * 2 - AppSpacing.md) / 2,
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(item.icon, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(item.label, style: AppTextStyles.labelSmall),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.value!,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FullWidthDetail extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _FullWidthDetail({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.xs),
              Text(label, style: AppTextStyles.labelSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _StatusBadgeInline extends StatelessWidget {
  final String status;
  const _StatusBadgeInline({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: leadStatusBgColor(status),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        _capitalize(status),
        style: AppTextStyles.labelSmall.copyWith(
          color: leadStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}
