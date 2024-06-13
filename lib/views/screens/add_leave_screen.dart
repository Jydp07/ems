import 'package:ems/blocs/service_bloc/service_bloc.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_button.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:ems/views/common/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';

class AddLeaveScreen extends StatefulWidget {
  const AddLeaveScreen({super.key});

  @override
  State<AddLeaveScreen> createState() => _AddLeaveScreenState();
}

class _AddLeaveScreenState extends State<AddLeaveScreen> with RouteAware {
  final leaveKey = GlobalKey<FormState>();
  final descritpionController = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          "Add Leave Request",
          color: ThemeConstant.primaryColor,
        ),
      ),
      body: Center(
        child: Form(
          key: leaveKey,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.07,
              ),
              MyTextField(
                controller: descritpionController,
                validator:
                    ValidationBuilder(requiredMessage: "Reason require")
                        .maxLength(30)
                        .minLength(1)
                        .build(),
                prefix: const Icon(Icons.description),
                hintText: "Enter Reason",
              ),
              SizedBox(
                height: size.height * 0.012,
              ),
              MyTextField(
                controller: startDate,
                validator:
                    ValidationBuilder(requiredMessage: "Plese select a date")
                        .maxLength(30)
                        .minLength(1)
                        .build(),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                    initialDate: DateTime.now(),
                  );
                  startDate.text = date != null
                      ? DateFormat("dd MMM yyyy").format(date)
                      : "";
                },
                prefix: const Icon(Icons.date_range_outlined),
                hintText: "Select Start Date",
                keyBoardType: TextInputType.none,
              ),
              SizedBox(
                height: size.height * 0.012,
              ),
              BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  return MyTextField(
                    controller: endDate,
                    validator: ValidationBuilder(
                            requiredMessage: "Plese select a date")
                        .maxLength(30)
                        .minLength(1)
                        .build(),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                        initialDate: DateTime.now(),
                      );
                      endDate.text = date != null
                          ? DateFormat("dd MMM yyyy").format(date)
                          : "";
                    },
                    prefix: const Icon(Icons.date_range_outlined),
                    hintText: "Select End Date",
                    keyBoardType: TextInputType.none,
                  );
                },
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              BlocConsumer<ServiceBloc, ServiceState>(
                listener: (context, state) {
                  if (state.isRequestAdd) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: MyText("Add Request Successfully."),
                      ),
                    );
                    Navigator.pop(context,true);
                  }
                },
                builder: (context, state) {
                  return state.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MyButton(
                          onTap: () {
                            if (leaveKey.currentState!.validate()) {
                              BlocProvider.of<ServiceBloc>(context).add(
                                  AddLeave(
                                      description:
                                          descritpionController.text.trim(),
                                      startDate: startDate.text.trim(),
                                      endDate: endDate.text.trim()));
                              descritpionController.clear();
                              startDate.clear();
                              endDate.clear();
                            }
                          },
                          color: ThemeConstant.secondaryColor,
                          height: size.height * 0.05,
                          width: size.width * 0.4,
                          child: const MyText(
                            "Add Request",
                            color: ThemeConstant.primaryColor,
                          ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descritpionController.dispose();
    startDate.dispose();
    endDate.dispose();
    super.dispose();
  }
}
