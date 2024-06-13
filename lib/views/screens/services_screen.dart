import 'package:ems/blocs/service_bloc/service_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/help_screen.dart';
import 'package:ems/views/screens/leaves_screen.dart';
import 'package:ems/views/screens/salary_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Services",
          color: ThemeConstant.primaryColor,
        ),
        centerTitle: true,
      ),
      body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 4 / 3),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ServiceBloc()..add(GetLeavesData()),
                      child: const LeavesScreen(),
                    ),
                  ),
                );
              },
              child: serviceWidget(
                  title: "Leaves", iconData: Icons.edit_calendar_rounded),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => ServiceBloc()..add(GetAllSalary()),
                        child: const SalaryHistoryScreen(
                          whichPage: "Attendance",
                        ),
                      ),
                    ),
                  );
                },
                child: serviceWidget(
                    title: "Attendance", iconData: Icons.calendar_month)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => ServiceBloc()..add(GetAllSalary()),
                        child: const SalaryHistoryScreen(
                          whichPage: "Salary",
                        ),
                      ),
                    ),
                  );
                },
                child: serviceWidget(
                    title: "Payroll", iconData: Icons.currency_rupee)),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HelpScreen()));
                },
                child:
                    serviceWidget(title: "Help", iconData: Icons.question_mark))
          ]),
    );
  }

  Widget serviceWidget({String? title, IconData? iconData}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            color: ThemeConstant.secondaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(-3, 3), blurRadius: 2),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: ThemeConstant.primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  iconData!,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyText(
              title!,
              color: ThemeConstant.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
