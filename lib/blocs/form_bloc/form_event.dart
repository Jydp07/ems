part of 'form_bloc.dart';

enum Status { signIn, signUp, forgetPassword, updateProfile}

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends FormEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends FormEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class NameChanged extends FormEvent {
  final String name;
  const NameChanged(this.name);

  @override
  List<Object> get props => [name];
}
class NumberChanged extends FormEvent {
  final String number;
  const NumberChanged(this.number);

  @override
  List<Object> get props => [number];
}

class GenderChanged extends FormEvent {
  final String gender;
  const GenderChanged(this.gender);

  @override
  List<Object> get props => [gender];
}
class DOBChanged extends FormEvent {
  final DateTime? dob;
  const DOBChanged(this.dob);

  @override
  List<Object?> get props => [dob];
}

class DOJChanged extends FormEvent {
  final DateTime? doj;
  const DOJChanged(this.doj);

  @override
  List<Object?> get props => [doj];
}

class ImageChanged extends FormEvent{
  @override
  List<Object?> get props => [];
}

class ForgetPassword extends FormEvent{
  const ForgetPassword();
  @override
  List<Object> get props => [];
}

class FormSubmittedSignUp extends FormEvent {
  final Status value;
  const FormSubmittedSignUp({required this.value});

  @override
  List<Object> get props => [value];
}

class FormSucceeded extends FormEvent {
  const FormSucceeded();

  @override
  List<Object> get props => [];
}

class GetUserData extends FormEvent{
  @override
  List<Object?> get props => [];
}

class GetAllUserData extends FormEvent{
  @override
  List<Object?> get props => [];
}

class SignOut extends FormEvent{
  @override
  List<Object?> get props => [];
}