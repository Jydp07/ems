import 'package:ems/blocs/admin_bloc/admin_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpAttendanceScreen extends StatelessWidget {
  const EmpAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Your Attendance",
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
          } else if (state.allDurationsData.isEmpty) {
            return const Center(
              child: MyText("You have not salary data."),
            );
          }
          final days = DateUtils.getDaysInMonth(
              DateTime.now().year, DateTime.now().month);
          final firstDay =
              DateTime(DateTime.now().year, DateTime.now().month, 1).weekday;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText("Mon"),
                    MyText("Tue"),
                    MyText("Wed"),
                    MyText("Thu"),
                    MyText("Fri"),
                    MyText("Sat"),
                    MyText("Sun"),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: days + (firstDay - 1),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7),
                  itemBuilder: (context, index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (index < firstDay - 1) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              backgroundColor: ThemeConstant.secondaryColor,
                              child: MyText(
                                "",
                                color: ThemeConstant.primaryColor,
                              ),
                            ),
                          );
                        }
                        if (state.allDates.contains("${index + 1}")) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              backgroundColor: ThemeConstant.secondaryColor,
                              child: MyText(
                                "${index + 1 - (firstDay - 1)}",
                                color: ThemeConstant.primaryColor,
                              ),
                            ),
                          );
                        } else if (index + 1 > int.parse(state.allDates.last)) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 14, 134, 18),
                              child: MyText(
                                "${index + 1 - (firstDay - 1)}",
                                color: ThemeConstant.primaryColor,
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: MyText(
                              "${index + 1 - (firstDay - 1)}",
                              color: ThemeConstant.primaryColor,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
