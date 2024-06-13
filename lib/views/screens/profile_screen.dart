import 'package:cached_network_image/cached_network_image.dart';
import 'package:ems/blocs/form_bloc/form_bloc.dart';
import 'package:ems/blocs/worktime_bloc/worktime_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/edit_screen.dart';
import 'package:ems/views/screens/login_screen.dart';
import 'package:ems/views/screens/show_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FormBloc()..add(GetUserData()),
        ),
        BlocProvider(
          create: (context) => WorktimeBloc(),
        ),
      ],
      child: const _ProfileScreen(),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Profile",
          color: ThemeConstant.primaryColor,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<FormBloc>(context).add(GetUserData());
        },
        child: ListView(
          children: [
            BlocConsumer<FormBloc, FormValidateState>(
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
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Stack(children: [
                              if (state.userModel.image == null)
                                const CircleAvatar(
                                  radius: 40,
                                  child: MyText("Image"),
                                )
                              else
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ShowPhotoScreen(
                                                url: state.userModel.image!)));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      state.userModel.image!,
                                    ),
                                    radius: 40,
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    BlocProvider.of<FormBloc>(context).add(
                                      ImageChanged(),
                                    );
                                  },
                                  child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black54),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: ThemeConstant.primaryColor,
                                        ),
                                      )),
                                ),
                              )
                            ]),
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
                              MyText(state.userModel.position ?? "")
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.9,
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
                                      MyText(
                                          "  ${state.userModel.salary ?? ""}"),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              listener: (BuildContext context, FormValidateState state) {
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
            ),
            BlocBuilder<FormBloc, FormValidateState>(
              builder: (context, state) {
                return ListTile(
                  title: const MyText("Edit Profile"),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => FormBloc()..add(GetUserData()),
                          child: EditProfileScreen(
                            userModel: state.userModel,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const MyText("LogOut"),
              trailing: const Icon(Icons.logout),
              onTap: () {
                final formBloc = BlocProvider.of<FormBloc>(context);
                final worktimeBloc = BlocProvider.of<WorktimeBloc>(context);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: const MyText("Are you sure?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  formBloc.add(SignOut());
                                  worktimeBloc.add(TimerCancel());
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LogInScreen(),
                                    ),
                                  );
                                },
                                child: const MyText("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const MyText("No"))
                          ],
                        ));
              },
            )
          ],
        ),
      ),
    );
  }
}
