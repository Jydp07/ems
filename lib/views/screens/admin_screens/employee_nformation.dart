import 'package:ems/blocs/admin_bloc/admin_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/admin_screens/emp_checkinoit.dart';
import 'package:ems/views/screens/admin_screens/emp_leave_screen.dart';
import 'package:ems/views/screens/admin_screens/emp_profile_screen.dart';
import 'package:ems/views/screens/admin_screens/emp_salary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeInformationScreen extends StatelessWidget {
  const EmployeeInformationScreen({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Employee Information",
          color: ThemeConstant.primaryColor,
        ),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmpProfile(
                    uid: uid,
                  ),
                ),
              );
            },
            child: _empWidget(size, Icons.info_outline, "Information"),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) =>
                          AdminBloc()..add(GetCheckInOutDataAdmin(uid: uid)),
                      child: EmpCheckInOut(uid: uid),
                    ),
                  ),
                );
              },
              child:
                  _empWidget(size, Icons.watch_later_outlined, "Check In-Out")),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => AdminBloc()
                        ..add(
                          GetAllSalaryAdmin(uid: uid),
                        ),
                      child: EmpSalaryScreen(
                        whichPage: "Salary",
                        uid: uid,
                      ),
                    ),
                  ),
                );
              },
              child: _empWidget(size, Icons.currency_rupee, "Salary")),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) =>
                          AdminBloc()..add(GetAllSalaryAdmin(uid: uid)),
                      child: EmpSalaryScreen(
                        whichPage: "Attendance",
                        uid: uid,
                      ),
                    ),
                  ),
                );
              },
              child: _empWidget(size, Icons.calendar_month, "Attendance")),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => AdminBloc()
                      ..add(
                        GetLeavesDataAdmin(uid: uid),
                      )
                      ..add(
                        GetUserByUid(uid: uid),
                      ),
                    child: EmpLeavesScreen(
                      uid: uid,
                    ),
                  ),
                ),
              );
            },
            child: _empWidget(
                size, Icons.airline_seat_recline_extra_rounded, "Leaves"),
          )
        ],
      ),
    );
  }

  Widget _empWidget(Size size, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.height * 0.1,
        width: size.width * 0.4,
        decoration: BoxDecoration(
          color: ThemeConstant.secondaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 3)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size.height * 0.05,
              color: ThemeConstant.primaryColor,
            ),
            MyText(
              text,
              fontWeight: FontWeight.w600,
              color: ThemeConstant.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
