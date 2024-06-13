import 'package:ems/blocs/cubit/visiblity_cubit.dart';
import 'package:ems/blocs/form_bloc/form_bloc.dart';
import 'package:ems/constant/routing_constant.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_button.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/common/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FormBloc(),
        ),
        BlocProvider(
          create: (context) => VisiblityCubit(),
        )
      ],
      child: const _RegistrationScreen(),
    );
  }
}

class _RegistrationScreen extends StatelessWidget {
  const _RegistrationScreen();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formBloc = BlocProvider.of<FormBloc>(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormValidateState>(listener: (context, state) {
          if (state.error.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: MyText(state.error),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const MyText("Okay"))
                ],
              ),
            );
          } else if (state.isLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutingConstant.bottombar, (route) => false);
          }
        }),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: ThemeConstant.primaryColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.035,
                        ),
                        Image.asset(
                          "assets/png/dwella.png",
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: ThemeConstant.secondaryColor,
                  ),
                )
              ],
            ),
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: SizedBox(
                height: size.height * 0.82,
                width: size.width * 0.9,
                child: Card(
                  elevation: 5,
                  color: ThemeConstant.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const MyText(
                            "Create Account",
                            color: ThemeConstant.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          const MyText(
                            "Welcome to Dwella start your journy with Registration",
                            color: ThemeConstant.greyColor,
                            textAlign: TextAlign.center,
                            fontSize: 12,
                          ),
                          SizedBox(
                            height: size.height * 0.012,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return MyTextField(
                                hintText: "Your Name",
                                error: state.isUserNameValid
                                    ? null
                                    : "UserName is Required",
                                onChanged: (value) {
                                  formBloc.add(NameChanged(value));
                                },
                                prefix: const Icon(Icons.person_outlined),
                              );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.012,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return MyTextField(
                                hintText: "Email",
                                error: state.isEmailValid
                                    ? null
                                    : "Please enter valid email",
                                keyBoardType: TextInputType.emailAddress,
                                prefix: const Icon(Icons.email_outlined),
                                onChanged: (value) {
                                  formBloc.add(EmailChanged(value));
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.012,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return BlocBuilder<VisiblityCubit,
                                  VisiblityState>(
                                builder: (context, visiblityState) {
                                  return MyTextField(
                                    hintText: "Password",
                                    error: state.isPasswordValid
                                        ? null
                                        : "Passwrod must contain special character.",
                                    keyBoardType: TextInputType.visiblePassword,
                                    isVisible: visiblityState.isVisible,
                                    prefix: const Icon(Icons.password_outlined),
                                    onChanged: (value) {
                                      formBloc.add(PasswordChanged(value));
                                    },
                                    suffix: IconButton(
                                      onPressed: () {
                                        BlocProvider.of<VisiblityCubit>(context)
                                            .onChangeVisiblity(
                                                !visiblityState.isVisible);
                                      },
                                      icon: Icon(visiblityState.isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.012,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return MyTextField(
                                hintText: "Phone",
                                error: state.isPhoneValid
                                    ? null
                                    : "Enter valid mobile number.",
                                keyBoardType: TextInputType.phone,
                                prefix: const Icon(Icons.phone_outlined),
                                onChanged: (value) {
                                  formBloc.add(NumberChanged(value));
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.012,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return MyTextField(
                                onTap: () async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1985),
                                      lastDate: DateTime.now(),
                                      initialDate: DateTime.now());
                                  formBloc.add(
                                    DOBChanged(
                                      date,
                                    ),
                                  );
                                },
                                error: state.isDobValid
                                    ? null
                                    : "Age must be greater than 18.",
                                keyBoardType: TextInputType.none,
                                hintText: state.dob == null
                                    ? "  DOB"
                                    : "  ${DateFormat("dd MMM yyyy").format(state.dob!)}",
                                suffix: const Icon(Icons.cake),
                              );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.012,
                          ),
                          BlocConsumer<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return _dropDownButton(
                                  size, context, state.gender);
                            },
                            listener: (BuildContext context,
                                FormValidateState state) {
                              if (!state.isGenderValid) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    content:
                                        const MyText("Please Select Gender."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const MyText("Okay"))
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return MyTextField(
                                error: state.isJobValid
                                    ? null
                                    : "Enter proper date of joining.",
                                onTap: () async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1985),
                                      lastDate: DateTime.now(),
                                      initialDate: DateTime.now());
                                  formBloc.add(
                                    DOJChanged(date),
                                  );
                                },
                                keyBoardType: TextInputType.none,
                                hintText: state.jod == null
                                    ? "  Joining Date"
                                    : "  ${DateFormat("dd MMM yyyy").format(state.jod!)}",
                                suffix: const Icon(Icons.calendar_month),
                              );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return state.isLoading
                                  ? const CircularProgressIndicator()
                                  : MyButton(
                                      onTap: () {
                                        formBloc.add(
                                          const FormSubmittedSignUp(
                                              value: Status.signUp),
                                        );
                                      },
                                      color: ThemeConstant.secondaryColor,
                                      height: size.height * 0.05,
                                      width: size.width * 0.4,
                                      child: const MyText(
                                        "Register",
                                        color: ThemeConstant.primaryColor,
                                      ),
                                    );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const MyText(
                                "Already have an account?",
                                color: Colors.black,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutingConstant.loginScreen);
                                  },
                                  child: const MyText(
                                    " LogIn",
                                    color: Colors.blue,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dropDownButton(Size size, BuildContext context, String gender) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        border: Border.all(color: Colors.black45),
      ),
      height: size.height * 0.06,
      width: size.width * 0.8,
      child: DropdownButton(
          underline: const SizedBox(),
          iconSize: 40,
          icon: const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Icon(Icons.arrow_drop_down_outlined)],
            ),
          ),
          hint: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 10),
            child: MyText(
              gender.isEmpty ? "Slect Gender" : gender,
              color: Colors.black54,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: "Male",
              child: MyText("Male"),
            ),
            DropdownMenuItem(
              value: "Female",
              child: MyText("Female"),
            )
          ],
          onChanged: (value) {
            BlocProvider.of<FormBloc>(context).add(GenderChanged(value!));
          }),
    );
  }
}
