import 'package:ems/blocs/form_bloc/form_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/models/user_model.dart';
import 'package:ems/views/common/my_button.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/common/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final editKey = GlobalKey<FormState>();
  DateTime? date;

  @override
  void initState() {
    nameController.text = widget.userModel.username ?? "";
    mobileController.text = widget.userModel.phone ?? "";
    dobController.text = DateFormat("dd MMM yyyy")
        .format(widget.userModel.dob?.toDate() ?? DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Edit Profile",
          color: ThemeConstant.primaryColor,
        ),
      ),
      body: Center(
        child: Form(
          key: editKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Image.asset(
                "assets/png/dwella.png",
                height: size.height * 0.2,
                semanticLabel: "Logo",
                width: size.width * 0.8,
                colorBlendMode: BlendMode.srcOut,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              MyTextField(
                controller: nameController,
                validator:
                    ValidationBuilder().minLength(2).maxLength(10).build(),
                prefix: const Icon(Icons.person),
                hintText: "Enter name.",
              ),
              const SizedBox(
                height: 8,
              ),
              MyTextField(
                controller: mobileController,
                validator: ValidationBuilder(
                        requiredMessage: "Mobile number must 10 digits.")
                    .minLength(10)
                    .maxLength(10)
                    .build(),
                hintText: "Enter Mobile No.",
                keyBoardType: TextInputType.number,
                prefix: const Icon(Icons.phone),
              ),
              const SizedBox(
                height: 8,
              ),
              MyTextField(
                controller: dobController,
                validator: ValidationBuilder().minLength(2).build(),
                prefix: const Icon(Icons.cake),
                onTap: () async {
                  date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1985),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now());
                  // ignore: use_build_context_synchronously
                  dobController.text = DateFormat("dd MMM yyyy")
                      .format(date ?? widget.userModel.dob!.toDate());
                },
                keyBoardType: TextInputType.none,
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              BlocConsumer<FormBloc, FormValidateState>(
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
                  }
                },
                builder: (context, state) {
                  return state.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MyButton(
                          onTap: () {
                            if (editKey.currentState!.validate()) {
                              BlocProvider.of<FormBloc>(context).add(
                                NameChanged(nameController.text),
                              );
                              BlocProvider.of<FormBloc>(context).add(
                                NumberChanged(mobileController.text),
                              );
                              BlocProvider.of<FormBloc>(context).add(
                                DOBChanged(
                                  date ?? widget.userModel.dob!.toDate(),
                                ),
                              );
                              BlocProvider.of<FormBloc>(context).add(
                                const FormSubmittedSignUp(
                                    value: Status.updateProfile),
                              );
                            }
                          },
                          color: ThemeConstant.secondaryColor,
                          height: 40,
                          width: 200,
                          child: const MyText(
                            "Update Profile",
                            color: ThemeConstant.primaryColor,
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    super.dispose();
  }
}
