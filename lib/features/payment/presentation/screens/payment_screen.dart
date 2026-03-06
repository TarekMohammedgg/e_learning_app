import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/features/payment/data/model/payment_args.dart';
import 'package:e_learning_app/features/payment/data/repo/payment_repo.dart';
import 'package:e_learning_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:e_learning_app/features/payment/presentation/cubit/payment_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.args});
  final PaymentArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(PaymentRepo()),
      child: _PaymentScreenBody(args: args),
    );
  }
}

class _PaymentScreenBody extends StatelessWidget {
  const _PaymentScreenBody({required this.args});
  final PaymentArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: Text(AppStrings.payment, style: AppStyle.bold18),
        centerTitle: true,
      ),
      body: BlocConsumer<PaymentCubit, PaymentStates>(
        listener: (context, state) {
          if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentSuccess) {
            return _buildSuccessView(context);
          }
          return _buildPaymentForm(context, state);
        },
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.successColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.successColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(AppStrings.paymentSuccessful, style: AppStyle.bold24),
            const SizedBox(height: 8),
            Text(
              AppStrings.enrolledSuccessfully,
              style: AppStyle.regular14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.layoutBottomNavBar,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.btnForground,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.goToMyCourses,
                  style: AppStyle.bold16.copyWith(
                    color: AppColors.btnForground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm(BuildContext context, PaymentStates state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.orderSummary, style: AppStyle.bold18),
                const SizedBox(height: 12),
                // Course Image + Title
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          args.courseImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.progressIndicatorBackground,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            args.courseTitle,
                            style: AppStyle.bold16,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${args.coursePrice} ${AppStrings.currency}',
                            style: AppStyle.bold18.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: AppColors.dividerColor),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.total, style: AppStyle.medium16),
                    Text(
                      '${args.coursePrice} ${AppStrings.currency}',
                      style: AppStyle.bold18.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Payment Method Section
          Text(AppStrings.paymentMethod, style: AppStyle.bold18),
          const SizedBox(height: 12),

          // Vodafone Cash Container
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Vodafone Cash Header (Red)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.vodafoneRed,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: AppColors.btnForground,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.vodafoneCash,
                        style: AppStyle.bold16.copyWith(
                          color: AppColors.btnForground,
                        ),
                      ),
                    ],
                  ),
                ),

                // Phone Number + Instructions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.sendAmountTo, style: AppStyle.regular14),
                      const SizedBox(height: 12),

                      // Phone Number Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.dividerColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_android,
                              color: AppColors.vodafoneRed,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppStrings.vodafoneNumber,
                              style: AppStyle.bold18.copyWith(
                                color: AppColors.textDark,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppStrings.numberCopied),
                                    backgroundColor: AppColors.successColor,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.vodafoneRed.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.copy,
                                  color: AppColors.vodafoneRed,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Amount to send
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.vodafoneRed.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.amountToSend,
                              style: AppStyle.medium14.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              '${args.coursePrice} ${AppStrings.currency}',
                              style: AppStyle.bold18.copyWith(
                                color: AppColors.vodafoneRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Confirm Payment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state is PaymentLoading
                  ? null
                  : () {
                      context.read<PaymentCubit>().processPayment(
                        courseId: args.courseId,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.btnForground,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state is PaymentLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.btnForground,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      AppStrings.confirmPayment,
                      style: AppStyle.bold16.copyWith(
                        color: AppColors.btnForground,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
