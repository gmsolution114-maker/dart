import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class ShimmerLeadCard extends StatelessWidget {
  const ShimmerLeadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.borderLight,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _shimmerBox(40, 40, radius: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(120, 14),
                      const SizedBox(height: 6),
                      _shimmerBox(80, 12),
                    ],
                  ),
                ),
                _shimmerBox(64, 24, radius: AppSpacing.radiusFull),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _shimmerBox(double.infinity, 12),
            const SizedBox(height: 8),
            _shimmerBox(200, 12),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _shimmerBox(90, 12),
                const SizedBox(width: AppSpacing.base),
                _shimmerBox(70, 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {double? radius}) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 6),
      ),
    );
  }
}

class ShimmerSummaryCard extends StatelessWidget {
  const ShimmerSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary.withValues(alpha: 0.15),
      highlightColor: AppColors.primary.withValues(alpha: 0.05),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        height: 120,
      ),
    );
  }
}
