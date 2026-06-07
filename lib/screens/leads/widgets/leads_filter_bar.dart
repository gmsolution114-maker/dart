import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/lead.dart';
import '../../../providers/leads_provider.dart';

class LeadsFilterBar extends StatelessWidget {
  final String searchQuery;
  final String? activeStatus;
  final SortOrder sortOrder;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<SortOrder> onSortChanged;

  static const _statuses = [
    ('All', null),
    ('New', 'new'),
    ('Contacted', 'contacted'),
    ('Qualified', 'qualified'),
    ('Converted', 'converted'),
    ('Lost', 'lost'),
  ];

  const LeadsFilterBar({
    super.key,
    required this.searchQuery,
    required this.activeStatus,
    required this.sortOrder,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search + Sort row
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.md,
            AppSpacing.base,
            0,
          ),
          child: Row(
            children: [
              Expanded(child: _SearchField(query: searchQuery, onChanged: onSearchChanged)),
              const SizedBox(width: AppSpacing.sm),
              _SortButton(current: sortOrder, onChanged: onSortChanged),
            ],
          ),
        ),
        // Status filter chips
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              AppSpacing.sm,
              AppSpacing.base,
              0,
            ),
            itemCount: _statuses.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final (label, value) = _statuses[index];
              final isSelected = (value == null && activeStatus == null) ||
                  (value != null && value == activeStatus);
              return _StatusChip(
                label: label,
                isSelected: isSelected,
                onTap: () => onStatusChanged(value),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatefulWidget {
  final String query;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.query, required this.onChanged});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      onChanged: widget.onChanged,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Search by name, email, city…',
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textTertiary),
        suffixIcon: _ctrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textTertiary),
                onPressed: () {
                  _ctrl.clear();
                  widget.onChanged('');
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final SortOrder current;
  final ValueChanged<SortOrder> onChanged;

  const _SortButton({required this.current, required this.onChanged});

  String get _label {
    return switch (current) {
      SortOrder.newestFirst => 'Newest',
      SortOrder.oldestFirst => 'Oldest',
      SortOrder.mostClicks => 'Top Clicks',
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOrder>(
      onSelected: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 4,
      color: AppColors.surface,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              _label,
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        _menuItem(SortOrder.newestFirst, 'Newest First', Icons.arrow_downward_rounded),
        _menuItem(SortOrder.oldestFirst, 'Oldest First', Icons.arrow_upward_rounded),
        _menuItem(SortOrder.mostClicks, 'Most Clicks', Icons.touch_app_rounded),
      ],
    );
  }

  PopupMenuItem<SortOrder> _menuItem(SortOrder value, String label, IconData icon) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
          if (current == value) ...[
            const Spacer(),
            const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
          ],
        ],
      ),
    );
  }
}

// Status color helpers used across widgets
Color leadStatusColor(String status) {
  return switch (status.toLowerCase()) {
    'contacted' => AppColors.statusContacted,
    'converted' => AppColors.statusConverted,
    'lost' => AppColors.statusLost,
    'qualified' => AppColors.statusQualified,
    _ => AppColors.statusNew,
  };
}

Color leadStatusBgColor(String status) {
  return switch (status.toLowerCase()) {
    'contacted' => AppColors.statusContactedBg,
    'converted' => AppColors.statusConvertedBg,
    'lost' => AppColors.statusLostBg,
    'qualified' => AppColors.statusQualifiedBg,
    _ => AppColors.statusNewBg,
  };
}
