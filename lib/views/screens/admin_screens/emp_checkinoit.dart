import 'package:ems/blocs/admin_bloc/admin_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmpCheckInOut extends StatefulWidget {
  const EmpCheckInOut({super.key, required this.uid});
  final String uid;

  @override
  State<EmpCheckInOut> createState() => _EmpCheckInOutState();
}

class _EmpCheckInOutState extends State<EmpCheckInOut>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const MyText(
            "Emp Check In-Out",
            color: ThemeConstant.primaryColor,
          ),
          bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ThemeConstant.primaryColor,
              indicatorColor: ThemeConstant.greyColor,
              tabs: [
                Tab(
                  text: "Check In",
                ),
                Tab(
                  text: "Check Out",
                )
              ]),
        ),
        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.error.isNotEmpty) {
              return Center(
                child: MyText(state.error),
              );
            } else if (state.allCheckInData.isEmpty) {
              return const Center(
                child: MyText("No Activity Found"),
              );
            }
            return TabBarView(
              children: [
                BlocBuilder<AdminBloc, AdminState>(
                  builder: (context, state) {
                    return checkInData(state, size);
                  },
                ),
                BlocBuilder<AdminBloc, AdminState>(
                  builder: (context, state) {
                    return checkOutData(state, size);
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget checkInData(AdminState state, Size size) {
    return ListView.builder(
        itemCount: state.allCheckInData.length,
        itemBuilder: (context, masterIndex) {
          return ExpansionTile(
            leading: const CircleAvatar(
              child: Icon(Icons.login),
            ),
            title: const MyText("Check In"),
            subtitle: MyText(DateFormat("dd MMM yyyy").format(
                state.allCheckInData[masterIndex].checkInTime?.first.toDate())),
            trailing: MyText(DateFormat("hh:mm a").format(
                state.allCheckInData[masterIndex].checkInTime?.first.toDate())),
            children: [
              SizedBox(
                height: size.height * 0.15,
                child: ListView.builder(
                  itemCount:
                      state.allCheckInData[masterIndex].checkInTime?.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.login),
                    ),
                    title: const MyText("Check In"),
                    subtitle: MyText(DateFormat("dd MMM yyyy").format(state
                        .allCheckInData[masterIndex].checkInTime?[index]
                        .toDate())),
                    trailing: MyText(DateFormat("hh:mm a").format(state
                        .allCheckInData[masterIndex].checkInTime?[index]
                        .toDate())),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget checkOutData(AdminState state, Size size) {
    return ListView.builder(
        itemCount: state.allCheckOutData.length,
        itemBuilder: (context, masterIndex) {
          return ExpansionTile(
            leading: const CircleAvatar(
              child: Icon(Icons.logout),
            ),
            title: const MyText("Check Out"),
            subtitle: MyText(DateFormat("dd MMM yyyy").format(state
                .allCheckOutData[masterIndex].checkOutTime?.first
                .toDate())),
            trailing: MyText(DateFormat("hh:mm a").format(state
                .allCheckOutData[masterIndex].checkOutTime?.first
                .toDate())),
            children: [
              SizedBox(
                height: size.height * 0.15,
                child: ListView.builder(
                  itemCount:
                      state.allCheckOutData[masterIndex].checkOutTime?.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.login),
                    ),
                    title: const MyText("Check Out"),
                    subtitle: MyText(DateFormat("dd MMM yyyy").format(state
                        .allCheckOutData[masterIndex].checkOutTime?[index]
                        .toDate())),
                    trailing: MyText(DateFormat("hh:mm a").format(state
                        .allCheckOutData[masterIndex].checkOutTime?[index]
                        .toDate())),
                  ),
                ),
              )
            ],
          );
        });
  }
}
