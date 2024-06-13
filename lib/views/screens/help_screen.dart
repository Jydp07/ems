import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          "Help Desk",
          color: ThemeConstant.primaryColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                "How your salary will be count?",
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              SizedBox(
                height: 10,
              ),
              MyText(
                "You have to work 234 hours per month. So your salary count based on hours you have to check in when you enter in the office. Or check out before leave the office.",
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 10,
              ),
              MyText(
                "Note: You can not CheckIn or CheckOut from your home so be carefull. Your salary may effected.",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 30,
              ),
              MyText(
                "How to apply for leave?",
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              SizedBox(
                height: 10,
              ),
              MyText(
                "Go to leave screen from service screen at the top right corner press \'+\' icon add your request. This request will be approve or denied by the company.",
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 30,
              ),
              MyText(
                "How to check daily durations and salaries?",
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              SizedBox(
                height: 10,
              ),
              MyText(
                "In service page you can navigate to the salary page here you can see your aily time durations and salary.",
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 30,
              ),
              MyText(
                "Other :",
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              SizedBox(
                height: 10,
              ),
              MyText(
                "You can see your profile data and also edit this data but you can edit only limited data. Your salary and position is defined by the company. Based on this salary data your salary will be count.",
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }
}
