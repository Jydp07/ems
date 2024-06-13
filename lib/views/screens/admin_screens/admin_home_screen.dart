import 'package:cached_network_image/cached_network_image.dart';
import 'package:ems/blocs/form_bloc/form_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/admin_screens/employee_nformation.dart';
import 'package:ems/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormBloc()..add(GetAllUserData()),
      child: const _AdminHomeScreen(),
    );
  }
}

class _AdminHomeScreen extends StatelessWidget {
  const _AdminHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Employee List",
          color: ThemeConstant.primaryColor,
        ),
        actions: [
          IconButton(
              onPressed: () {
                final formBloc = BlocProvider.of<FormBloc>(context);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: const MyText("Are you sure?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  formBloc.add(SignOut());
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
              icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocBuilder<FormBloc, FormValidateState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error.isNotEmpty) {
            return Center(
              child: MyText(state.error),
            );
          } else if (state.getAllUserData.isEmpty) {
            return const Center(
              child: MyText("Employee Not Found"),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<FormBloc>(context).add(GetAllUserData());
            },
            child: ListView.builder(
              itemCount: state.getAllUserData.length,
              itemBuilder: (context, index) {
                final userData = state.getAllUserData[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmployeeInformationScreen(
                                  uid: userData.uid!,
                                )));
                  },
                  leading: userData.image == null
                      ? CircleAvatar(
                          child: MyText(userData.username!
                              .substring(0, 2)
                              .toString()
                              .toUpperCase()))
                      : CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(userData.image!),
                          ),
                  title: MyText(userData.username ?? ""),
                  subtitle: MyText(userData.position ?? ""),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
