import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/provider/auth_provider.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _pinFormKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final idNumberCtrl = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> pinControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> confirmPinControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  String _selectedIdType = 'National ID';
  bool _showOtpField = false;

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
    phoneCtrl.text = '+254 ';
  }

  void _showOtpDialog() {
    for (var controller in otpControllers) {
      controller.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: 24,
                  ),
                  decoration: BoxDecoration(
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
                          style: GoogleFonts.lexend(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),

                        SizedBox(height: 16),

                        Text(
                          'Enter the 4-digit code sent to ${phoneCtrl.text}',
                          style: GoogleFonts.lexend(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),

                        SizedBox(height: 24),

                        Form(
                          key: _otpFormKey,
                          child: Row(
                            children: [
                              for (int i = 0; i < 4; i++) ...[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: TextFormField(
                                      controller: otpControllers[i],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      style: GoogleFonts.lexend(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.02,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.length == 1 && i < 3) {
                                          FocusScope.of(context).nextFocus();
                                        } else if (value.isEmpty && i > 0) {
                                          FocusScope.of(
                                            context,
                                          ).previousFocus();
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
                        ),

                        SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.lexend(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.04,
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
                                  if (_otpFormKey.currentState!.validate()) {
                                    String otpValue =
                                        otpControllers
                                            .map(
                                              (controller) => controller.text,
                                            )
                                            .join();
                                    if (otpValue.length != 4) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please enter complete 4-digit OTP',
                                            style: GoogleFonts.lexend(),
                                          ),
                                          backgroundColor: Colors.red[400],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.pop(context);
                                    _showPinDialog();
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
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                ),
                                child: Text(
                                  'Verify OTP',
                                  style: GoogleFonts.lexend(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.04,
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

  void _showPinDialog() {
    for (var controller in pinControllers) {
      controller.clear();
    }
    for (var controller in confirmPinControllers) {
      controller.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: 24,
                  ),
                  decoration: BoxDecoration(
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
                          'Set Your PIN',
                          style: GoogleFonts.lexend(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),

                        SizedBox(height: 16),

                        Text(
                          'Create a 4-digit PIN for your account',
                          style: GoogleFonts.lexend(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),

                        SizedBox(height: 24),

                        Form(
                          key: _pinFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter PIN',
                                style: GoogleFonts.lexend(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
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
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: TextFormField(
                                          controller: pinControllers[i],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          obscureText: true,
                                          style: GoogleFonts.lexend(
                                            fontSize:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.02,
                                                ),
                                          ),
                                          onChanged: (value) {
                                            if (value.length == 1 && i < 3) {
                                              FocusScope.of(
                                                context,
                                              ).nextFocus();
                                            } else if (value.isEmpty && i > 0) {
                                              FocusScope.of(
                                                context,
                                              ).previousFocus();
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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

                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),

                              Text(
                                'Confirm PIN',
                                style: GoogleFonts.lexend(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
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
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: TextFormField(
                                          controller: confirmPinControllers[i],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          obscureText: true,
                                          style: GoogleFonts.lexend(
                                            fontSize:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.02,
                                                ),
                                          ),
                                          onChanged: (value) {
                                            if (value.length == 1 && i < 3) {
                                              FocusScope.of(
                                                context,
                                              ).nextFocus();
                                            } else if (value.isEmpty && i > 0) {
                                              FocusScope.of(
                                                context,
                                              ).previousFocus();
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                        ),

                        SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.lexend(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.04,
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
                                  if (_pinFormKey.currentState!.validate()) {
                                    String pinValue =
                                        pinControllers
                                            .map(
                                              (controller) => controller.text,
                                            )
                                            .join();
                                    String confirmPinValue =
                                        confirmPinControllers
                                            .map(
                                              (controller) => controller.text,
                                            )
                                            .join();
                                    if (pinValue.length != 4 ||
                                        confirmPinValue.length != 4) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please enter complete 4-digit PINs',
                                            style: GoogleFonts.lexend(),
                                          ),
                                          backgroundColor: Colors.red[400],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    if (pinValue != confirmPinValue) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'PINs do not match',
                                            style: GoogleFonts.lexend(),
                                          ),
                                          backgroundColor: Colors.red[400],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    try {
                                      final auth = Provider.of<AuthProvider>(
                                        context,
                                        listen: false,
                                      );
                                      // Map display name to backend value
                                      final idTypeMap = {
                                        'National ID': 'national_id',
                                        'Passport': 'passport',
                                        'Military ID': 'military_id',
                                        'Alien ID': 'alien_id',
                                        'Birth Certificate':
                                            'birth_certificate',
                                      };
                                      final backendIdType =
                                          idTypeMap[_selectedIdType] ??
                                          _selectedIdType;
                                      await auth.register(
                                        nameCtrl.text.trim(),
                                        phoneCtrl.text.trim(),
                                        pinValue,
                                        idType: backendIdType,
                                        idNumber: idNumberCtrl.text.trim(),
                                      );
                                      // Show OTP dialog for verification
                                      _showOtpDialog();
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.toString(),
                                            style: GoogleFonts.lexend(),
                                          ),
                                          backgroundColor: Colors.red[400],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                ),
                                child: Text(
                                  'Create Account',
                                  style: GoogleFonts.lexend(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.04,
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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700]),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

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
                      offset: Offset(0, 2),
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
                'Create Account',
                style: GoogleFonts.lexend(
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Join our maternal care community',
                style: GoogleFonts.lexend(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.grey[600],
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
                        labelText: 'Select ID Type',
                        labelStyle: GoogleFonts.lexend(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                      items:
                          _idTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: GoogleFonts.lexend(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
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
                      style: GoogleFonts.lexend(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[800],
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),

                    TextFormField(
                      controller: idNumberCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.lexend(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      decoration: InputDecoration(
                        labelText: 'ID Number',
                        labelStyle: GoogleFonts.lexend(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
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

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),

                    TextFormField(
                      controller: nameCtrl,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.lexend(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: GoogleFonts.lexend(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
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
                          return 'Please enter your first name';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),

                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.lexend(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'e.g. 0712345678',
                        labelStyle: GoogleFonts.lexend(color: Colors.grey[600]),
                        hintStyle: GoogleFonts.lexend(color: Colors.grey[400]),
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
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '+254',
                                style: GoogleFonts.lexend(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
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
                          return 'Please enter your phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton(
                        onPressed:
                            auth.loading
                                ? null
                                : () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      // Simulate sending OTP
                                      await Future.delayed(
                                        Duration(seconds: 1),
                                      ); // Mock API call
                                      setState(() {
                                        _showOtpField = true;
                                      });
                                      _showOtpDialog();
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to send OTP: ${e.toString()}',
                                            style: GoogleFonts.lexend(),
                                          ),
                                          backgroundColor: Colors.red[400],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                        ),
                        child:
                            auth.loading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  'Proceed',
                                  style: GoogleFonts.lexend(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.04,
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
                    "Already have an account? ",
                    style: GoogleFonts.lexend(
                      color: Colors.grey[600],
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.lexend(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              Text(
                'Safe • Supportive • Secure',
                style: GoogleFonts.lexend(
                  color: Colors.grey[500],
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    idNumberCtrl.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var controller in confirmPinControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
