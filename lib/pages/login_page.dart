import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/provider/auth_provider.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final idNumberCtrl = TextEditingController();
  final List<TextEditingController> pinControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final updatePhoneCtrl = TextEditingController();
  final updateIdNumberCtrl = TextEditingController();

  String _selectedIdType = 'National ID';
  String _selectedUpdateIdType = 'National ID';
  bool _isSubmitting = false;

  final List<String> _idTypes = [
    'National ID',
    'Passport',
    'Military ID',
    'Alien ID',
    'Birth Certificate',
  ];

  @override
  void initState() {
    super.initState();
    updatePhoneCtrl.text = '+254 ';
  }

  void _showUpdatePhoneDialog(BuildContext context) {
    updatePhoneCtrl.text = '+254 ';
    updateIdNumberCtrl.clear();
    _selectedUpdateIdType = 'National ID';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            top: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Update Phone Number',
                  style: GoogleFonts.afacad(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedUpdateIdType,
                  decoration: InputDecoration(
                    labelText: 'ID Type',
                    labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  items: _idTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        style: GoogleFonts.afacad(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setDialogState(() {
                      _selectedUpdateIdType = newValue!;
                    });
                  },
                  style: GoogleFonts.afacad(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: updateIdNumberCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.afacad(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  decoration: InputDecoration(
                    labelText: 'ID Number',
                    labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: updatePhoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.afacad(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🇰🇪',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.045,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '+254',
                            style: GoogleFonts.afacad(
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.afacad(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Phone number updated successfully',
                                style: GoogleFonts.afacad(),
                              ),
                              backgroundColor: Colors.green[400],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: GoogleFonts.afacad(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPinValue() {
    return pinControllers.map((controller) => controller.text).join();
  }

  String _getOtpValue() {
    return otpControllers.map((controller) => controller.text).join();
  }
void _showOtpDialog(BuildContext context, AuthProvider auth) async {
  print('Entering _showOtpDialog');
  for (var controller in otpControllers) {
    controller.clear();
  }
  
  // Create a new form key specifically for the OTP dialog
  final otpFormKey = GlobalKey<FormState>();
  
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (dialogContext) => Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
        left: MediaQuery.of(dialogContext).size.width * 0.05,
        right: MediaQuery.of(dialogContext).size.width * 0.05,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter OTP',
              style: GoogleFonts.afacad(
                fontSize: MediaQuery.of(dialogContext).size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Enter the 4-digit OTP sent to your phone',
              style: GoogleFonts.afacad(
                fontSize: MediaQuery.of(dialogContext).size.width * 0.035,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24), // Increased spacing
            Form(
              key: otpFormKey, // Using the dedicated form key
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        controller: otpControllers[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: GoogleFonts.afacad(
                          fontSize: MediaQuery.of(dialogContext).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && i < 3) {
                            FocusScope.of(dialogContext).nextFocus();
                          } else if (value.isEmpty && i > 0) {
                            FocusScope.of(dialogContext).previousFocus();
                          }
                          
                          // Auto-submit when all fields are filled
                          if (i == 3 && value.isNotEmpty) {
                            String otpValue = _getOtpValue();
                            if (otpValue.length == 4) {
                              // You can optionally auto-submit here
                              // _verifyOtp(dialogContext, auth, otpValue);
                            }
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      print('OTP dialog cancelled');
                      Navigator.of(dialogContext).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(dialogContext).size.height * 0.02,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.afacad(
                        fontSize: MediaQuery.of(dialogContext).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (otpFormKey.currentState!.validate()) {
                        String otpValue = _getOtpValue();
                        print('Submitting OTP: $otpValue');
                        if (otpValue.length != 4) {
                          print('Invalid OTP length');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter complete 4-digit OTP',
                                style: GoogleFonts.afacad(),
                              ),
                              backgroundColor: Colors.red[400],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                          return;
                        }
                        try {
                          print('Calling auth.verifyOtp...');
                          await auth.verifyOtp(
                            idNumberCtrl.text.trim(),
                            otpValue,
                            context: context,
                          );
                          print('OTP verified, navigating to HomePage');
                          Navigator.of(dialogContext).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        } catch (e) {
                          print('Error verifying OTP: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString().replaceAll('Exception: ', ''),
                                style: GoogleFonts.afacad(),
                              ),
                              backgroundColor: Colors.red[400],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(dialogContext).size.height * 0.02,
                      ),
                    ),
                    child: Text(
                      'Verify',
                      style: GoogleFonts.afacad(
                        fontSize: MediaQuery.of(dialogContext).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
  print('Exiting _showOtpDialog');
}

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Container(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Text(
                    'MAMA HEALTH',
                    style: GoogleFonts.afacad(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Maternal Care & Support',
                    style: GoogleFonts.afacad(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedIdType,
                          decoration: InputDecoration(
                            labelText: 'ID Type',
                            labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.04,
                              vertical: MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                          items: _idTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: GoogleFonts.afacad(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedIdType = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select ID type';
                            }
                            return null;
                          },
                          style: GoogleFonts.afacad(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        TextFormField(
                          controller: idNumberCtrl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.afacad(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                          decoration: InputDecoration(
                            labelText: 'ID Number',
                            labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.04,
                              vertical: MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your ID number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter your 4-digit Pin',
                              style: GoogleFonts.afacad(
                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                for (int i = 0; i < 4; i++) ...[
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      child: TextFormField(
                                        controller: pinControllers[i],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        style: GoogleFonts.afacad(
                                          fontSize: MediaQuery.of(context).size.width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context).size.height * 0.02,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          if (value.length == 1 && i < 3) {
                                            FocusScope.of(context).nextFocus();
                                          } else if (value.isEmpty && i > 0) {
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: auth.loading || _isSubmitting
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      String pinValue = _getPinValue();
                                      if (pinValue.length != 4) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please enter complete 4-digit PIN',
                                              style: GoogleFonts.afacad(),
                                            ),
                                            backgroundColor: Colors.red[400],
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        _isSubmitting = true;
                                      });
                                      try {
                                        print('Calling auth.login...');
                                        await auth.login(
                                          idNumberCtrl.text.trim(),
                                          pinValue,
                                          _selectedIdType == 'National ID'
                                              ? 'national_id'
                                              : _selectedIdType.toLowerCase(),
                                        );
                                        print('Showing OTP dialog...');
                                        _showOtpDialog(context, auth);
                                      } catch (e) {
                                        print('Error during login: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              e.toString().replaceAll('Exception: ', ''),
                                              style: GoogleFonts.afacad(),
                                            ),
                                            backgroundColor: Colors.red[400],
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                      } finally {
                                        setState(() {
                                          _isSubmitting = false;
                                        });
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: auth.loading || _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Sign In',
                                    style: GoogleFonts.afacad(
                                      fontSize: MediaQuery.of(context).size.width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.afacad(
                          color: Colors.grey[600],
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        ),
                        child: Text(
                          'Register',
                          style: GoogleFonts.afacad(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  GestureDetector(
                    onTap: () => _showUpdatePhoneDialog(context),
                    child: Text(
                      'Update Phone Number',
                      style: GoogleFonts.afacad(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    idNumberCtrl.dispose();
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var controller in otpControllers) {
      controller.dispose();
    }
    updatePhoneCtrl.dispose();
    updateIdNumberCtrl.dispose();
    super.dispose();
  }
}