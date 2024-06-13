import 'package:ems/blocs/admin_bloc/admin_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpDailyDurationScreen extends StatelessWidget {
  const EmpDailyDurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Daily Durations",
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
              child: MyText("Employee have not salary."),
            );
          }
          
          
          return ListView.builder(
              itemCount: state.allDurationsData.length,
              itemBuilder: (context, index) {
                
                final salaryPerSecond = state.userModel.salary ?? 0;
                final salary = state.allDurationsData[index].seconds! *
                    salaryPerSecond /
                    842400;
                return ListTile(
                  title: MyText(state.allDurationsData[index].uid ?? ""),
                  subtitle: MyText(
                      "${Duration(seconds: state.allDurationsData[index].seconds ?? 0).inHours.toString().padLeft(2, '0')}:${Duration(seconds: state.allDurationsData[index].seconds ?? 0).inMinutes.remainder(60).toString().padLeft(2, '0')}:${Duration(seconds: state.allDurationsData[index].seconds ?? 0).inSeconds.remainder(60).toString().padLeft(2, '0')}"),
                  trailing: MyText(salary.toStringAsFixed(2)),
                );
              });
        },
      ),
    );
  }
}
