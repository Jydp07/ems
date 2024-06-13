import 'package:ems/blocs/service_bloc/service_bloc.dart';
import 'package:ems/blocs/worktime_bloc/worktime_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/attendance_screen.dart';
import 'package:ems/views/screens/daily_duration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SalaryHistoryScreen extends StatelessWidget {
  const SalaryHistoryScreen({super.key, required this.whichPage});
  final String whichPage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          "$whichPage History",
          color: ThemeConstant.primaryColor,
        ),
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
          } else if (state.salaryData.isEmpty) {
            return const Center(
              child: MyText("You have not salary data."),
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
                            create: (context) => WorktimeBloc()
                              ..add(
                                GetAllDurations(
                                    month: state.salaryData[index].dateTime!
                                        .toDate()
                                        .month),
                              ),
                            child: const DailyDurationScreen(),
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => WorktimeBloc()
                              ..add(GetAllDurations(
                                  month: state.salaryData[index].dateTime!
                                      .toDate()
                                      .month)),
                            child: const AttendanceScreen(),
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
              });
        },
      ),
    );
  }
}
