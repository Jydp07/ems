import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/models/user_model.dart';
import 'package:ems/repository/authentication_repository.dart';
import 'package:ems/repository/database_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormValidateState> {
  FormBloc()
      : super(FormValidateState(
            isFormValid: false,
            isLoading: false,
            error: "",
            isUserNameValid: true,
            userName: "",
            isEmailValid: true,
            email: "",
            password: "",
            isPasswordValid: true,
            isPhoneValid: true,
            phone: "",
            dob: null,
            isDobValid: true,
            isGenderValid: true,
            gender: "",
            isJobValid: true,
            jod: null,
            isLoggedIn: false,
            userModel: UserModel(),
            image: "",
            isSignOut: false,
            getAllUserData: const [])) {
    on<NameChanged>(_userNameChanged);
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanges);
    on<NumberChanged>(_phoneChanges);
    on<DOBChanged>(_dobChanges);
    on<GenderChanged>(_genderChanges);
    on<DOJChanged>(_dojChanges);
    on<FormSubmittedSignUp>(_formSubmitted);
    on<GetUserData>(_getUserData);
    on<ImageChanged>(_imageChanged);
    on<SignOut>(_signOut);
    on<GetAllUserData>(_getAllUsersData);
  }

  bool _userNameValid(String userName) {
    return userName.isNotEmpty;
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  bool _emailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$',
  );

  bool _passwordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  bool _phoneValid(String password) {
    return password.length == 10;
  }

  bool _dobValid(DateTime? dob) {
    return dob != null &&
        dob.isBefore(DateTime.now().subtract(const Duration(days: 6570)));
  }

  bool _jobValid(DateTime? jod) {
    return jod != null;
  }

  bool _genderValid(String gender) {
    return gender.isNotEmpty;
  }

  _userNameChanged(NameChanged event, Emitter<FormValidateState> emit) {
    emit(state.copyWith(
        userName: event.name,
        isUserNameValid: _userNameValid(event.name),
        isFormValid: false,
        error: ""));
  }

  _emailChanged(EmailChanged event, Emitter<FormValidateState> emit) {
    emit(state.copyWith(
        email: event.email,
        isEmailValid: _emailValid(event.email),
        error: "",
        isFormValid: false));
  }

  _passwordChanges(PasswordChanged event, Emitter<FormValidateState> emit) {
    emit(state.copyWith(
        password: event.password,
        isPasswordValid: _passwordValid(event.password),
        error: "",
        isFormValid: false));
  }

  _phoneChanges(NumberChanged event, Emitter<FormValidateState> emit) {
    emit(state.copyWith(
        phone: event.number,
        isPhoneValid: _phoneValid(event.number),
        error: "",
        isFormValid: false));
  }

  _dobChanges(DOBChanged event, Emitter<FormValidateState> emit) {
    emit(state.copyWith(
        dob: event.dob,
        isDobValid: _dobValid(event.dob),
        error: "",
        isFormValid: false));
  }

  _genderChanges(GenderChanged event, Emitter<FormValidateState> emit) {
    emit(state.copyWith(
        gender: event.gender,
        isGenderValid: _genderValid(event.gender),
        error: "",
        isFormValid: false));
  }

  _dojChanges(DOJChanged event, Emitter<FormValidateState> emit) {
    emit(state.copyWith(
        jod: event.doj,
        isJobValid: _jobValid(event.doj),
        error: "",
        isFormValid: false));
  }

  _formSubmitted(
      FormSubmittedSignUp event, Emitter<FormValidateState> emit) async {
    if (event.value == Status.signUp) {
      emit(state.copyWith(
          error: "",
          isFormValid: state.isEmailValid &&
              state.isPasswordValid &&
              state.isUserNameValid &&
              state.isGenderValid &&
              state.isDobValid &&
              state.isJobValid &&
              state.isPhoneValid));
      if (state.isFormValid) {
        emit(state.copyWith(isLoading: true));
        try {
          final authRepo = AuthenticationRepository();

          await authRepo.createUser(state.email, state.password);
          final dbRepo = DatabaseRepository();
          final userModel = UserModel();
          final uid = FirebaseAuth.instance.currentUser?.uid;
          await dbRepo
              .addUserData(
                userModel.copyWith(
                    email: state.email,
                    uid: uid,
                    username: state.userName,
                    phone: state.phone,
                    dob: Timestamp.fromDate(state.dob!),
                    doj: Timestamp.fromDate(state.jod!),
                    gender: state.gender),
              )
              .then(
                (val) => emit(
                  state.copyWith(isLoggedIn: true),
                ),
              );
        } catch (ex) {
          emit(state.copyWith(error: ex.toString()));
        } finally {
          emit(state.copyWith(isLoading: false, error: "", isLoggedIn: false));
        }
      } else {
        emit(
          state.copyWith(error: "Please fill form properly."),
        );
      }
    } else if (event.value == Status.signIn) {
      emit(state.copyWith(
          error: "", isFormValid: state.isEmailValid && state.isPasswordValid));
      if (state.isFormValid) {
        emit(state.copyWith(isLoading: true));
        try {
          final authRepo = AuthenticationRepository();
          await authRepo.authenticateUser(state.email, state.password).then(
                (value) => emit(
                  state.copyWith(isLoggedIn: true),
                ),
              );
        } catch (ex) {
          emit(state.copyWith(error: ex.toString()));
        } finally {
          emit(state.copyWith(isLoading: false, error: "", isLoggedIn: false));
        }
      } else {
        emit(
          state.copyWith(error: "Please fill form properly."),
        );
      }
    } else if (event.value == Status.updateProfile) {
      emit(state.copyWith(error: "", isFormValid: state.isDobValid));
      if (state.isFormValid) {
        emit(state.copyWith(isLoading: true));
        try {
          final dbRepo = DatabaseRepository();
          final userModel = UserModel();
          final uid = FirebaseAuth.instance.currentUser?.uid;
          await dbRepo.updateUserData(userModel.copyWith(
              uid: uid,
              username: state.userName,
              phone: state.phone,
              dob: Timestamp.fromDate(state.dob!)));
        } catch (ex) {
          emit(state.copyWith(error: ex.toString()));
        } finally {
          emit(state.copyWith(isLoading: false, error: "", isLoggedIn: false));
        }
      } else {
        emit(state.copyWith(error: "Age must be grater than 18."));
      }
      emit(state.copyWith(error: ""));
    }
  }

  final _dbRepo = DatabaseRepository();
  _getUserData(GetUserData event, Emitter<FormValidateState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final userModel = UserModel();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final userData = await _dbRepo.getUserData(userModel.copyWith(uid: uid));
      emit(state.copyWith(userModel: userData));
    } catch (ex) {
      emit(
        state.copyWith(
          error: ex.toString(),
        ),
      );
    } finally {
      emit(state.copyWith(isLoading: false, error: ""));
    }
  }

  _imageChanged(ImageChanged event, Emitter<FormValidateState> emit) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        final userModel = UserModel();
        await _dbRepo.uploadImageAndUpdate(
            File(image.path), userModel.copyWith(uid: uid));
        add(GetUserData());
        emit(state.copyWith(image: image.path));
      }
    } catch (ex) {
      emit(
        state.copyWith(
          error: ex.toString(),
        ),
      );
      log(ex.toString());
    } finally {
      emit(state.copyWith(isLoading: false, error: ""));
    }
  }

  _signOut(SignOut event, Emitter<FormValidateState> emit) async {
    try {
      final authRepo = AuthenticationRepository();
      await authRepo.signOut().whenComplete(
            () => emit(
              state.copyWith(isSignOut: true),
            ),
          );
    } catch (ex) {
      emit(
        state.copyWith(
          error: ex.toString(),
        ),
      );
      log(ex.toString());
    } finally {
      emit(state.copyWith(isLoading: false, error: "", isSignOut: false));
    }
  }

  _getAllUsersData(
      GetAllUserData event, Emitter<FormValidateState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      log("message");
      final data = await _dbRepo.getAllUsers();
      log(data.toString());
      emit(state.copyWith(getAllUserData: data));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
      log(ex.toString());
    } finally {
      emit(state.copyWith(error: "", isLoading: false));
    }
  }
}
