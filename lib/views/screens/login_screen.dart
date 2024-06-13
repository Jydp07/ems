import 'package:ems/blocs/cubit/visiblity_cubit.dart';
import 'package:ems/blocs/form_bloc/form_bloc.dart';
import 'package:ems/constant/routing_constant.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_button.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/common/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FormBloc(),
        ),
        BlocProvider(
          create: (context) => VisiblityCubit(),
        ),
      ],
      child: const _LogInScreen(),
    );
  }
}

class _LogInScreen extends StatelessWidget {
  const _LogInScreen();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<FormBloc, FormValidateState>(
      listener: (context, state) {
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
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == "BFZEL3CJRoOf3mthtOR9sJaA4Dz1") {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutingConstant.adminHome, (route) => false);
          } else{
            Navigator.pushNamedAndRemoveUntil(
                context, RoutingConstant.bottombar, (route) => false);
          }
        }
      },
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
                          height: size.height * 0.04,
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
                height: size.height * 0.8,
                width: size.width * 0.9,
                child: Card(
                  color: ThemeConstant.primaryColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const MyText(
                            "Welcome Back",
                            color: ThemeConstant.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          const MyText(
                            "LogIn with Email and Password",
                            color: ThemeConstant.greyColor,
                            textAlign: TextAlign.center,
                            fontSize: 12,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return MyTextField(
                                hintText: "Email",
                                error: state.isEmailValid
                                    ? null
                                    : "Enter valid email.",
                                keyBoardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  BlocProvider.of<FormBloc>(context)
                                      .add(EmailChanged(value));
                                },
                                prefix: const Icon(Icons.email_outlined),
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
                                    error: state.isPasswordValid
                                        ? null
                                        : "Password must contain 8 letters.",
                                    hintText: "Password",
                                    keyBoardType: TextInputType.visiblePassword,
                                    onChanged: (value) {
                                      BlocProvider.of<FormBloc>(context)
                                          .add(PasswordChanged(value));
                                    },
                                    prefix: const Icon(Icons.password_outlined),
                                    isVisible: visiblityState.isVisible,
                                    suffix: BlocBuilder<VisiblityCubit,
                                        VisiblityState>(
                                      builder: (context, state) {
                                        return IconButton(
                                            onPressed: () {
                                              BlocProvider.of<VisiblityCubit>(
                                                      context)
                                                  .onChangeVisiblity(
                                                      !state.isVisible);
                                            },
                                            icon: Icon(state.isVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off));
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          BlocBuilder<FormBloc, FormValidateState>(
                            builder: (context, state) {
                              return state.isLoading
                                  ? const CircularProgressIndicator()
                                  : MyButton(
                                      onTap: () {
                                        BlocProvider.of<FormBloc>(context).add(
                                            const FormSubmittedSignUp(
                                                value: Status.signIn));
                                      },
                                      color: ThemeConstant.secondaryColor,
                                      height: size.height * 0.05,
                                      width: size.width * 0.4,
                                      child: const MyText(
                                        "LogIn",
                                        color: ThemeConstant.primaryColor,
                                      ),
                                    );
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: MyText("Forgot password?"),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.33,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const MyText("Don't have an account?"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RoutingConstant.registrationScreen);
                                },
                                child: const MyText(
                                  " Register",
                                  color: Colors.blue,
                                ),
                              )
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
}
