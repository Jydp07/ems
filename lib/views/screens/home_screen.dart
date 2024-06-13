import 'package:cached_network_image/cached_network_image.dart';
import 'package:ems/blocs/form_bloc/form_bloc.dart';
import 'package:ems/blocs/worktime_bloc/worktime_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/screens/show_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WorktimeBloc()
            ..add(CurrentWorkingHours())
            ..add(GetLocation())
            ..add(GetCheckInOutData()),
        ),
        BlocProvider(
          create: (context) => FormBloc()..add(GetUserData()),
        ),
      ],
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<WorktimeBloc, WorktimeState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: MyText(state.error),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const MyText("Okay"))
              ],
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: ThemeConstant.secondaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<FormBloc, FormValidateState>(
                              builder: (context, state) {
                                return state.userModel.image != null
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.05,
                                            left: size.width * 0.05),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ShowPhotoScreen(
                                                    url:
                                                        state.userModel.image!),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    state.userModel.image!),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.05,
                                            left: size.width * 0.05),
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                              "assets/png/dwella.png"),
                                        ),
                                      );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.05,
                                  horizontal: size.width * 0.05),
                              child: BlocBuilder<FormBloc, FormValidateState>(
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        state.userModel.username ?? "",
                                        fontSize: 25,
                                        color: ThemeConstant.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      MyText(
                                        state.userModel.position ?? "",
                                        fontSize: 12,
                                        color: ThemeConstant.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.05,
                              horizontal: size.width * 0.05),
                          child: IconButton(
                            onPressed: () {
                              BlocProvider.of<FormBloc>(context)
                                  .add(GetUserData());
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: ThemeConstant.primaryColor,
                              size: 30,
                            ),
                            tooltip: "Refresh",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    color: ThemeConstant.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.18,
                          ),
                          const MyText("Your Activity"),
                          BlocBuilder<WorktimeBloc, WorktimeState>(
                            builder: (context, state) {
                              if (state.error.isNotEmpty) {
                                return Center(
                                  child: MyText(state.error),
                                );
                              } else if (state.allCheckInData.isEmpty) {
                                return const Center(
                                  child: MyText("No Activity Found"),
                                );
                              }
                              return DefaultTabController(
                                length: 2,
                                child: Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const TabBar(
                                          indicatorColor:
                                              ThemeConstant.secondaryColor,
                                          labelColor:
                                              ThemeConstant.secondaryColor,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          tabs: [
                                            Tab(
                                              text: "Check In",
                                            ),
                                            Tab(
                                              text: "Check Out",
                                            )
                                          ]),
                                      Expanded(
                                        child: TabBarView(children: [
                                          _checkInData(state, size),
                                          _checkOutData(state, size)
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: size.height * 0.17,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: SizedBox(
                height: size.height * 0.3,
                width: size.width * 0.9,
                child: Card(
                  elevation: 4,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              MyText(
                                DateFormat(" EE, dd MMM yyyy")
                                    .format(DateTime.now()),
                                fontSize: 13,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.watch_later_outlined),
                              BlocBuilder<WorktimeBloc, WorktimeState>(
                                builder: (context, state) {
                                  return MyText(
                                    DateFormat(" hh:mm a")
                                        .format(state.timeOfDay),
                                    fontSize: 13,
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    BlocBuilder<WorktimeBloc, WorktimeState>(
                      builder: (context, state) {
                        return _timerWidget(size, state.workingHours);
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    const MyText(
                      "General time 09:00 AM to 06:00 PM",
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    BlocBuilder<WorktimeBloc, WorktimeState>(
                      builder: (context, state) {
                        return _checkInOutButton(size, state, context);
                      },
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    BlocProvider.of<WorktimeBloc>(context).add(TimerCancel());
    super.dispose();
  }

  Widget _timerWidget(Size size, Duration workTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.06,
          width: size.width * 0.13,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 179, 201, 239),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: MyText(
              workTime.inHours.toString().padLeft(2, "0"),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.03,
        ),
        Container(
          height: size.height * 0.06,
          width: size.width * 0.13,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 179, 201, 239),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: MyText(
              workTime.inMinutes.remainder(60).toString().padLeft(2, "0"),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.03,
        ),
        Container(
          height: size.height * 0.06,
          width: size.width * 0.13,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 179, 201, 239),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: MyText(
              workTime.inSeconds.remainder(60).toString().padLeft(2, "0"),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.02,
        ),
        const MyText(
          "HRS",
          color: ThemeConstant.secondaryColor,
          fontWeight: FontWeight.bold,
        )
      ],
    );
  }

  Widget _checkInOutButton(
      Size size, WorktimeState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: size.height * 0.055,
            width: size.width * 0.38,
            decoration: BoxDecoration(
                border: Border.all(color: ThemeConstant.secondaryColor),
                borderRadius: BorderRadius.circular(4)),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.currency_rupee),
                MyText(
                  state.allSalary.toStringAsFixed(2),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ],
            )),
          ),
          state.isLoading || state.workingModel.uid == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: () {
                    if (state.workingModel.isCheckedIn == null) {
                      BlocProvider.of<WorktimeBloc>(context)
                          .add(CheckIn(checkInTime: DateTime.now()));
                      BlocProvider.of<WorktimeBloc>(context)
                          .add(CheckInOutData());
                    } else {
                      BlocProvider.of<WorktimeBloc>(context)
                          .add(CheckOut(checkOutTime: DateTime.now()));

                      BlocProvider.of<WorktimeBloc>(context)
                          .add(CheckInOutData());
                    }
                  },
                  child: Container(
                    height: size.height * 0.055,
                    width: size.width * 0.38,
                    decoration: BoxDecoration(
                        color: state.workingModel.isCheckedIn != null
                            ? Colors.red
                            : ThemeConstant.secondaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(-3, 3),
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state.workingModel.isCheckedIn != null
                                ? Icons.logout_outlined
                                : Icons.login_outlined,
                            color: ThemeConstant.primaryColor,
                          ),
                          MyText(
                            state.workingModel.isCheckedIn != null
                                ? " Check Out"
                                : " Check In",
                            color: ThemeConstant.primaryColor,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget _checkInData(WorktimeState state, Size size) {
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

  Widget _checkOutData(WorktimeState state, Size size) {
    return ListView.builder(
      itemCount: state.allCheckOutData.length,
      itemBuilder: (context, masterIndex) {
        return ExpansionTile(
          leading: const CircleAvatar(
            child: Icon(Icons.logout),
          ),
          title: const MyText("Check Out"),
          subtitle: MyText(DateFormat("dd MMM yyyy").format(
              state.allCheckOutData[masterIndex].checkOutTime?.first.toDate())),
          trailing: MyText(DateFormat("hh:mm a").format(
              state.allCheckOutData[masterIndex].checkOutTime?.first.toDate())),
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
                  subtitle: MyText(
                    DateFormat("dd MMM yyyy").format(
                      state.allCheckOutData[masterIndex].checkOutTime?[index]
                          .toDate(),
                    ),
                  ),
                  trailing: MyText(
                    DateFormat("hh:mm a").format(
                      state.allCheckOutData[masterIndex].checkOutTime?[index]
                          .toDate(),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
