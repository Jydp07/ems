import 'package:ems/blocs/admin_bloc/admin_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/admin_screens/emp_attendance_screen.dart';
import 'package:ems/views/screens/admin_screens/emp_daily_durations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmpSalaryScreen extends StatelessWidget {
  const EmpSalaryScreen(
      {super.key, required this.whichPage, required this.uid});
  final String whichPage;
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          "$whichPage History",
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
          } else if (state.salaryData.isEmpty) {
            return const Center(
              child: MyText("Employee have not salary data."),
            );
          }
          return ListView.builder(
            itemCount: state.salaryData.length,
            itemBuilder: (context, index) {
              final data = state.salaryData[index];
              return ListTile(
                onTap: () {
                  if (whichPage == "Salary") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => AdminBloc()
                            ..add(GetAllDurationsAdmin(
                                uid: uid,
                                month: state.salaryData[index].dateTime!
                                    .toDate()
                                    .month)),
                          child: const EmpDailyDurationScreen(),
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => AdminBloc()
                            ..add(GetAllDurationsAdmin(
                                uid: uid,
                                month: state.salaryData[index].dateTime!
                                    .toDate()
                                    .month)),
                          child: const EmpAttendanceScreen(),
                        ),
                      ),
                    );
                  }
                },
                leading: const CircleAvatar(
                  child: Icon(Icons.currency_rupee_sharp),
                ),
                title: MyText(
                    DateFormat("MMM yyyy").format(data.dateTime!.toDate())),
                subtitle: MyText(data.salary!.toStringAsFixed(2)),
              );
            },
          );
        },
      ),
    );
  }
}
