import 'package:e_learning_app/features/payment/data/repo/payment_repo.dart';
import 'package:e_learning_app/features/payment/presentation/cubit/payment_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  final PaymentRepo paymentRepo;
  PaymentCubit(this.paymentRepo) : super(PaymentInitial());

  Future<void> processPayment({required String courseId}) async {
    emit(PaymentLoading());
    final result = await paymentRepo.processPayment(courseId: courseId);
    result.fold(
      (error) {
        if (!isClosed) emit(PaymentError(error));
      },
      (_) {
        if (!isClosed) emit(PaymentSuccess());
      },
    );
  }
}
