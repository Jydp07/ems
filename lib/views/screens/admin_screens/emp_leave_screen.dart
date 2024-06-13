import 'package:cached_network_image/cached_network_image.dart';
import 'package:ems/blocs/admin_bloc/admin_bloc.dart';
import 'package:ems/blocs/service_bloc/service_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class EmpLeavesScreen extends StatelessWidget {
  const EmpLeavesScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const MyText(
          "Emp Leaves",
          color: ThemeConstant.primaryColor,
        ),
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
          } else if (state.leaveData.isEmpty) {
            return const Center(
              child: MyText("Employee haven't take a leave."),
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
                return Slidable(
                  direction: Axis.horizontal,
                  closeOnScroll: true,
                  key: Key(data.uid!),
                  startActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        BlocProvider.of<AdminBloc>(context).add(
                            AcceptDeniedLeaves(
                                isAccept: false,
                                userId: uid,
                                uid: state.leaveData[index].uid!));
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.cancel,
                      label: 'Denied',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        BlocProvider.of<AdminBloc>(context).add(
                            AcceptDeniedLeaves(
                                isAccept: true,
                                userId: uid,
                                uid: state.leaveData[index].uid!));
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.done,
                      label: 'Accept',
                    )
                  ]),
                  child: Column(
                    children: [
                      ListTile(
                        leading: state.userModel.image == null
                            ? CircleAvatar(
                                child: MyText(state.userModel.username ??
                                    "".substring(0, 2).toUpperCase()),
                              )
                            : CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    state.userModel.image!),
                              ),
                        title: MyText(state.userModel.username ?? ''),
                        subtitle: MyText(
                          "${data.description ?? ""}\nLeave Date ${data.startDate} -- ${data.endDate}\nRequest Date ${DateFormat("dd MMM yyyy").format(data.requestAt!.toDate())}",
                          fontSize: 12,
                        ),
                        trailing: MyText(data.isApprove == null
                            ? "Pending"
                            : data.isApprove!
                                ? "Accept"
                                : "Denied"),
                      ),
                      const Divider(
                        height: 1,
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
