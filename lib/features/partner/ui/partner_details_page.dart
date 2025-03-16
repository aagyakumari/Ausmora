import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/ask_a_question/ui/ask_a_question_page.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/partner/model/partner_details_model.dart';
import 'package:flutter_application_1/features/partner/repo/partner_details_repo.dart';
import 'package:flutter_application_1/features/partner/service/partner_details_service.dart';
import 'package:flutter_application_1/features/partner/ui/detail_section.dart';
import 'package:intl/intl.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key});

  @override
  _PartnerDetailsPageState createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthTimeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await PartnerDetailsServices.selectDate(context);
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat.yMMMd().format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await PartnerDetailsServices.selectTime(context);
    if (picked != null) {
      setState(() {
        _birthTimeController.text = picked.format(context);
      });
    }
  }

  void _navigateToAskQuestion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AskQuestionPage()),
    );
  }

  Future<void> _submitDetails() async {
    final details = PartnerDetailsModel(
      name: _nameController.text,
      location: _locationController.text,
      birthDate: _birthDateController.text,
      birthTime: _birthTimeController.text,
      question: _questionController.text,
    );
    final repository = PartnerDetailsRepository();
    await repository.submitDetails(details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  const Text(
                    'Enter your partner\'s details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFFF9933),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DetailSection(
                    label: 'Name',
                    hintText: 'Enter their name',
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                  ),
                  DetailSection(
                    label: 'From',
                    hintText: 'Enter their location',
                    keyboardType: TextInputType.text,
                    controller: _locationController,
                  ),
                  DetailSection(
                    label: 'Born on',
                    hintText: 'Enter their birth date',
                    keyboardType: TextInputType.datetime,
                    onTap: () => _selectDate(context),
                    controller: _birthDateController,
                  ),
                  DetailSection(
                    label: 'At',
                    hintText: 'Enter their birth time',
                    keyboardType: TextInputType.datetime,
                    onTap: () => _selectTime(context),
                    controller: _birthTimeController,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _questionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFFF9933), width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFFF9933), width: 2.0),
                          ),
                          hintText: 'Enter your question',
                          hintStyle: const TextStyle(
                              color: Colors.white70, fontFamily: 'Inter'),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_forward,
                                color: Color(0xFFFF9933)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardPage()),
                              );
                            },
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _submitDetails();
                      _navigateToAskQuestion(context);
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      color: const Color(0xFFFF9933),
                      child: const Text(
                        'IDEAS WHAT TO ASK',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
