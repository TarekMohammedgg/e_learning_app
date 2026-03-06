abstract class PaymentStates {}

class PaymentInitial extends PaymentStates {}

class PaymentLoading extends PaymentStates {}

class PaymentSuccess extends PaymentStates {}

class PaymentError extends PaymentStates {
  final String error;
  PaymentError(this.error);
}
