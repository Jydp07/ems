import 'package:cached_network_image/cached_network_image.dart';
import 'package:ems/blocs/admin_bloc/admin_bloc.dart';
import 'package:ems/blocs/worktime_bloc/worktime_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/models/user_model.dart';
import 'package:ems/views/common/my_button.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/common/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';

class EmpProfile extends StatelessWidget {
  const EmpProfile({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminBloc()..add(GetUserByUid(uid: uid)),
        ),
        BlocProvider(
          create: (context) => WorktimeBloc(),
        ),
      ],
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          return _ProfileScreen(uid, state.userModel);
        },
      ),
    );
  }
}

class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen(this.uid, this.userModel);
  final String uid;
  final UserModel userModel;
  @override
  State<_ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  final _positionCotroller = TextEditingController();
  final _salaryController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      _positionCotroller.text = widget.userModel.position ?? "";
      _salaryController.text = widget.userModel.salary == null
          ? " 0"
          : " ${widget.userModel.salary.toString()}";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Profile",
          color: ThemeConstant.primaryColor,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<AdminBloc>(context)
              .add(GetUserByUid(uid: widget.uid));
        },
        child: Form(
          key: _key,
          child: ListView(
            children: [
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  if (state.isLoading ||
                      state.userModel.dob == null ||
                      state.userModel.dob == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.error.isNotEmpty) {
                    return Center(
                      child: MyText(state.error),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: state.userModel.image == null
                                  ? CircleAvatar(
                                      radius: 40,
                                      child: MyText(
                                        state.userModel.username!
                                            .substring(0, 2)
                                            .toUpperCase(),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        state.userModel.image!,
                                      ),
                                      radius: 40,
                                    ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  state.userModel.username ?? "",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: MyTextField(
                                    controller: _positionCotroller,
                                    hintText: " Employee Position",
                                    validator: ValidationBuilder()
                                        .minLength(1)
                                        .build(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.99,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: ThemeConstant.secondaryColor,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const MyText(
                                          "  Email",
                                          color: ThemeConstant.greyColor,
                                        ),
                                        MyText("  ${state.userModel.email}"),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.015,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      color: ThemeConstant.secondaryColor,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const MyText(
                                          "  Mobile No.:",
                                          color: ThemeConstant.greyColor,
                                        ),
                                        MyText("  ${state.userModel.phone}"),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.015,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    state.userModel.gender == "Male"
                                        ? const Icon(
                                            Icons.male,
                                            color: ThemeConstant.secondaryColor,
                                          )
                                        : const Icon(
                                            Icons.female,
                                            color: ThemeConstant.secondaryColor,
                                          ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const MyText(
                                          "  Gender",
                                          color: ThemeConstant.greyColor,
                                        ),
                                        MyText('  ${state.userModel.gender}'),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.015,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.cake,
                                      color: ThemeConstant.secondaryColor,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const MyText(
                                          "  Birth Date",
                                          color: ThemeConstant.greyColor,
                                        ),
                                        MyText(
                                            "  ${DateFormat("dd MMM yyyy").format(state.userModel.dob!.toDate())}"),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.015,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.apartment,
                                      color: ThemeConstant.secondaryColor,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const MyText(
                                          "  Joining Date",
                                          color: ThemeConstant.greyColor,
                                        ),
                                        MyText(
                                            "  ${DateFormat("dd MMM yyyy").format(state.userModel.doj!.toDate())}"),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.015,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.currency_rupee_sharp,
                                      color: ThemeConstant.secondaryColor,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const MyText(
                                          "  Salary",
                                          color: ThemeConstant.greyColor,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.7,
                                          child: MyTextField(
                                            controller: _salaryController,
                                            hintText: " Employee Salary",
                                            validator: ValidationBuilder()
                                                .minLength(1)
                                                .build(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                state.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : MyButton(
                                        onTap: () async {
                                          if (_key.currentState!.validate()) {
                                            BlocProvider.of<AdminBloc>(context)
                                                .add(
                                              UpdateSalaryAndPosition(
                                                uid: widget.uid,
                                                position:
                                                    _positionCotroller.text,
                                                salary: double.parse(
                                                    _salaryController.text),
                                              ),
                                            );
                                          }
                                        },
                                        color: ThemeConstant.secondaryColor,
                                        height: size.height * 0.06,
                                        width: size.width * 0.8,
                                        child: const MyText(
                                          "Update",
                                          color: ThemeConstant.primaryColor,
                                        ),
                                      )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
