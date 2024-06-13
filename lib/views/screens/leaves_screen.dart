import 'package:ems/blocs/service_bloc/service_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/add_leave_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LeavesScreen extends StatelessWidget {
  const LeavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const MyText(
          "Leaves",
          color: ThemeConstant.primaryColor,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => ServiceBloc(),
                    child: const AddLeaveScreen(),
                  ),
                ),
              );
              if (result == true) {
                // ignore: use_build_context_synchronously
                BlocProvider.of<ServiceBloc>(context).add(GetLeavesData());
              }
            },
            icon: const Icon(Icons.add),
            tooltip: "Add Request",
          )
        ],
      ),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.error.isNotEmpty) {
            return Center(
              child: MyText(state.error),
            );
          } else if (state.leaveData.isEmpty) {
            return const Center(
              child: MyText("You haven't take a leave."),
            );
          }
          return RefreshIndicator(
            color: ThemeConstant.secondaryColor,
            onRefresh: () async {
              BlocProvider.of<ServiceBloc>(context).add(GetLeavesData());
            },
            child: ListView.builder(
              itemCount: state.leaveData.length,
              itemBuilder: (context, index) {
                final data = state.leaveData[index];
                return Column(
                  children: [
                    BlocConsumer<ServiceBloc, ServiceState>(
                      listener: (context, state) {
                        if (state.isRequestDeleted) {}
                      },
                      builder: (context, state) {
                        return Dismissible(
                          key: Key(state.leaveData[index].uid!),
                          background: Container(
                            color: Colors.red,
                            child: const Center(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            BlocProvider.of<ServiceBloc>(context).add(
                              DeleteData(
                                  uid: state.leaveData[index].uid!,
                                  context: context,
                                  index: index,
                                  serviceModel: state.leaveData[index]),
                            );
                            state.leaveData.remove(state.leaveData[index]);
                          },
                          child: ListTile(
                            title: MyText(data.description ?? ""),
                            subtitle: MyText(
                              "Leave Date ${data.startDate} -- ${data.endDate}\nRequest Date ${DateFormat("dd MMM yyyy").format(data.requestAt!.toDate())}",
                              fontSize: 12,
                            ),
                            trailing: MyText(data.isApprove == null
                                ? "Pending"
                                : data.isApprove!
                                    ? "Approved"
                                    : "Denied"),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
