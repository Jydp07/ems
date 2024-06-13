part of 'form_bloc.dart';

class FormValidateState extends Equatable {
  const FormValidateState(
      {required this.isFormValid,
      required this.isLoading,
      required this.error,
      required this.isUserNameValid,
      required this.userName,
      required this.isEmailValid,
      required this.email,
      required this.password,
      required this.isPasswordValid,
      required this.isPhoneValid,
      required this.phone,
      required this.dob,
      required this.image,
      required this.isDobValid,
      required this.isGenderValid,
      required this.gender,
      required this.userModel,
      required this.isJobValid,
      required this.isLoggedIn,
      required this.getAllUserData,
      required this.isSignOut,
      required this.jod});

  final bool isLoading;
  final String error;
  final bool isUserNameValid;
  final String userName;
  final bool isEmailValid;
  final String email;
  final String password;
  final String image;
  final UserModel userModel;
  final bool isPasswordValid;
  final bool isPhoneValid;
  final String phone;
  final DateTime? dob;
  final bool isDobValid;
  final bool isGenderValid;
  final String gender;
  final bool isJobValid;
  final bool isLoggedIn;
  final DateTime? jod;
  final bool isFormValid;
  final bool isSignOut;
  final List<UserModel> getAllUserData;

  FormValidateState copyWith({
    bool? isLoading,
    String? error,
    bool? isUserNameValid,
    String? userName,
    bool? isLoggedIn,
    bool? isEmailValid,
    String? email,
    String? image,
    bool? isSignOut,
    List<UserModel>? getAllUserData,
    UserModel? userModel,
    String? password,
    bool? isPasswordValid,
    bool? isPhoneValid,
    String? phone,
    DateTime? dob,
    bool? isDobValid,
    bool? isGenderValid,
    String? gender,
    bool? isJobValid,
    DateTime? jod,
    bool? isFormValid,
  }) {
    return FormValidateState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        isUserNameValid: isUserNameValid ?? this.isUserNameValid,
        userName: userName ?? this.userName,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        email: email ?? this.email,
        image: image ?? this.image,
        getAllUserData: getAllUserData ?? this.getAllUserData,
        isSignOut: isSignOut ?? this.isSignOut,
        userModel: userModel ?? this.userModel,
        password: password ?? this.password,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isPhoneValid: isPhoneValid ?? this.isPhoneValid,
        phone: phone ?? this.phone,
        dob: dob ?? this.dob,
        isDobValid: isDobValid ?? this.isDobValid,
        isGenderValid: isGenderValid ?? this.isGenderValid,
        gender: gender ?? this.gender,
        isJobValid: isJobValid ?? this.isJobValid,
        jod: jod ?? this.jod,
        isFormValid: isFormValid ?? this.isFormValid);
  }

  @override
  List<Object?> get props => [
        isFormValid,
        isLoading,
        error,
        isUserNameValid,
        userName,
        isEmailValid,
        isLoggedIn,
        email,
        isSignOut,
        userModel,
        password,
        getAllUserData,
        isPasswordValid,
        isPhoneValid,
        phone,
        dob,
        isDobValid,
        isGenderValid,
        image,
        gender,
        isJobValid,
        jod,
        isFormValid
      ];
}
