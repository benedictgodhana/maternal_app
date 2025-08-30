import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maternal_app/widgets/custom_appbar.dart';
import 'package:maternal_app/widgets/custom_bottom_navigation.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Sample payment data
  final List<Map<String, dynamic>> _pendingPayments = [
    {
      'id': '1',
      'title': 'Prenatal Appointment',
      'type': 'Appointment Fee',
      'amount': 75.00,
      'date': DateTime.now().add(const Duration(days: 1)),
      'notes': 'Consultation with Dr. Smith',
      'status': 'pending',
    },
    {
      'id': '2',
      'title': 'Lab Test Payment',
      'type': 'Lab Test',
      'amount': 50.00,
      'date': DateTime.now().add(const Duration(days: 2)),
      'notes': 'Blood panel test',
      'status': 'pending',
    },
  ];

  final List<Map<String, dynamic>> _completedPayments = [
    {
      'id': '3',
      'title': 'Monthly Subscription',
      'type': 'Subscription',
      'amount': 29.99,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'notes': 'Premium app access',
      'status': 'completed',
    },
    {
      'id': '4',
      'title': 'Ultrasound Session',
      'type': 'Medical',
      'amount': 120.00,
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'notes': '20-week ultrasound',
      'status': 'completed',
    },
  ];

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _policyNumberController = TextEditingController();
  final _memberIdController = TextEditingController();
  String? _selectedPaymentType;
  String? _selectedInsuranceProvider;

  // Available payment types and insurance providers
  final List<String> _paymentTypes = ['M-Pesa', 'Cash', 'Insurance Cover'];
  final List<String> _insuranceProviders = ['SHA', 'Jubilee'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneNumberController.dispose();
    _policyNumberController.dispose();
    _memberIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Payments',
              style: GoogleFonts.afacad(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8A4F7D),
              ),
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF8A4F7D),
              labelColor: const Color(0xFF8A4F7D),
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.afacad(fontWeight: FontWeight.w600),
              tabs: const [Tab(text: 'Pending'), Tab(text: 'Completed')],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pending Payments Tab
                _buildPaymentsList(_pendingPayments, true),

                // Completed Payments Tab
                _buildPaymentsList(_completedPayments, false),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: 3,
        onItemTapped: (index) {
          final routes = [
            '/home',
            '/appointment',
            '/reminders',
            '/payment',
            '/profile',
          ];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPaymentBottomSheet(context),
        backgroundColor: const Color(0xFF8A4F7D),
        child: const Icon(Iconsax.card_add, color: Colors.white),
      ),
    );
  }

  Widget _buildPaymentsList(
    List<Map<String, dynamic>> payments,
    bool isPending,
  ) {
    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending ? Iconsax.card : Iconsax.card_tick,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isPending ? 'No pending payments' : 'No completed payments',
              style: GoogleFonts.afacad(fontSize: 16, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              isPending
                  ? 'Add a payment method to get started'
                  : 'Your completed payments will appear here',
              style: GoogleFonts.afacad(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildPaymentCard(payment, isPending);
      },
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment, bool isPending) {
    final date = payment['date'] as DateTime;
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
    final status = payment['status'] as String;

    Color statusColor;
    String statusText;

    switch (status) {
      case 'pending':
        statusColor = const Color(0xFFFFA000);
        statusText = 'Pending';
        break;
      case 'completed':
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Completed';
        break;
      case 'cancelled':
        statusColor = const Color(0xFFF44336);
        statusText = 'Cancelled';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.afacad(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF555555),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.afacad(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'KSh ${payment['amount'].toStringAsFixed(2)}',
              style: GoogleFonts.afacad(
                fontSize: 14,
                color: const Color(0xFF8A4F7D),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A4F7D).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.card, color: Color(0xFF8A4F7D)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['title'],
                        style: GoogleFonts.afacad(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      Text(
                        payment['type'],
                        style: GoogleFonts.afacad(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Iconsax.note, size: 16, color: Color(0xFF8A4F7D)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    payment['notes'],
                    style: GoogleFonts.afacad(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isPending && status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => _showPaymentSelectionBottomSheet(
                            context,
                            payment,
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A4F7D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Pay Now',
                        style: GoogleFonts.afacad(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showCancelDialog(payment),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF44336),
                        side: const BorderSide(color: Color(0xFFF44336)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.afacad(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(height: 20),
                      Text(
                        'Add Payment Method',
                        style: GoogleFonts.afacad(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8A4F7D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentType,
                        decoration: InputDecoration(
                          labelText: 'Payment Type',
                          labelStyle: GoogleFonts.afacad(
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Iconsax.card,
                            color: Color(0xFF8A4F7D),
                          ),
                        ),
                        items:
                            _paymentTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type, style: GoogleFonts.afacad()),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPaymentType = newValue;
                            _phoneNumberController.clear();
                            _policyNumberController.clear();
                            _memberIdController.clear();
                            _selectedInsuranceProvider = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a payment type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_selectedPaymentType == 'M-Pesa')
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number (e.g., 2547XXXXXXXX)',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.mobile,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            if (!RegExp(r'^2547[0-9]{8}$').hasMatch(value)) {
                              return 'Enter a valid Safaricom number (e.g., 2547XXXXXXXX)';
                            }
                            return null;
                          },
                        ),
                      if (_selectedPaymentType == 'Insurance Cover') ...[
                        DropdownButtonFormField<String>(
                          value: _selectedInsuranceProvider,
                          decoration: InputDecoration(
                            labelText: 'Insurance Provider',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.shield,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          items:
                              _insuranceProviders.map((String provider) {
                                return DropdownMenuItem<String>(
                                  value: provider,
                                  child: Text(
                                    provider,
                                    style: GoogleFonts.afacad(),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedInsuranceProvider = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an insurance provider';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _policyNumberController,
                          decoration: InputDecoration(
                            labelText: 'Policy Number',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.document,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a policy number';
                            }
                            if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
                              return 'Policy number must be alphanumeric';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _memberIdController,
                          decoration: InputDecoration(
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.user,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a member ID';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _addPaymentMethod(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8A4F7D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Add Payment Method',
                            style: GoogleFonts.afacad(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _addPaymentMethod() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPaymentType == 'M-Pesa') {
        // Simulate saving M-Pesa phone number to backend
        // In a real app, you would:
        // 1. Register with Safaricom's Daraja API (https://developer.safaricom.co.ke)
        // 2. Use API credentials to authenticate
        // 3. Save phone number securely for STK Push
      } else if (_selectedPaymentType == 'Insurance Cover') {
        // Simulate saving insurance details to backend
        // In a real app, verify policy number and member ID with SHA/Jubilee API
      } else if (_selectedPaymentType == 'Cash') {
        // No additional data needed for Cash
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment method ($_selectedPaymentType) added successfully!',
            style: GoogleFonts.afacad(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Close the bottom sheet
      Navigator.pop(context);

      // Clear form
      _phoneNumberController.clear();
      _policyNumberController.clear();
      _memberIdController.clear();
      setState(() {
        _selectedPaymentType = null;
        _selectedInsuranceProvider = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields',
            style: GoogleFonts.afacad(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPaymentSelectionBottomSheet(
    BuildContext context,
    Map<String, dynamic> payment,
  ) {
    final paymentFormKey = GlobalKey<FormState>();
    final paymentPhoneNumberController = TextEditingController();
    final paymentPolicyNumberController = TextEditingController();
    final paymentMemberIdController = TextEditingController();
    String? selectedPaymentMethod;
    String? selectedInsuranceProvider;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: paymentFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(height: 20),
                      Text(
                        'Select Payment Method',
                        style: GoogleFonts.afacad(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8A4F7D),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Pay KSh ${payment['amount'].toStringAsFixed(2)} for "${payment['title']}"',
                        style: GoogleFonts.afacad(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedPaymentMethod,
                        decoration: InputDecoration(
                          labelText: 'Payment Method',
                          labelStyle: GoogleFonts.afacad(
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Iconsax.card,
                            color: Color(0xFF8A4F7D),
                          ),
                        ),
                        items:
                            _paymentTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type, style: GoogleFonts.afacad()),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPaymentMethod = newValue;
                            paymentPhoneNumberController.clear();
                            paymentPolicyNumberController.clear();
                            paymentMemberIdController.clear();
                            selectedInsuranceProvider = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a payment method';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (selectedPaymentMethod == 'M-Pesa')
                        TextFormField(
                          controller: paymentPhoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number (e.g., 2547XXXXXXXX)',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.mobile,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            if (!RegExp(r'^2547[0-9]{8}$').hasMatch(value)) {
                              return 'Enter a valid Safaricom number (e.g., 2547XXXXXXXX)';
                            }
                            return null;
                          },
                        ),
                      if (selectedPaymentMethod == 'Insurance Cover') ...[
                        DropdownButtonFormField<String>(
                          value: selectedInsuranceProvider,
                          decoration: InputDecoration(
                            labelText: 'Insurance Provider',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.shield,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          items:
                              _insuranceProviders.map((String provider) {
                                return DropdownMenuItem<String>(
                                  value: provider,
                                  child: Text(
                                    provider,
                                    style: GoogleFonts.afacad(),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedInsuranceProvider = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an insurance provider';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: paymentPolicyNumberController,
                          decoration: InputDecoration(
                            labelText: 'Policy Number',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.document,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a policy number';
                            }
                            if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
                              return 'Policy number must be alphanumeric';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: paymentMemberIdController,
                          decoration: InputDecoration(
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.afacad(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.user,
                              color: Color(0xFF8A4F7D),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a member ID';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (paymentFormKey.currentState!.validate()) {
                              if (selectedPaymentMethod == 'M-Pesa') {
                                Navigator.pop(context); // Close bottom sheet
                                _showMpesaPinDialog(
                                  context,
                                  payment,
                                  paymentPhoneNumberController.text,
                                );
                              } else {
                                // Handle Cash or Insurance payment
                                String message;
                                if (selectedPaymentMethod == 'Cash') {
                                  // Simulate cash payment instruction
                                  message =
                                      'Cash payment recorded. Please pay at the clinic.';
                                } else {
                                  // Simulate insurance payment
                                  // In a real app, verify policy with SHA/Jubilee API
                                  message =
                                      'Insurance payment processed successfully.';
                                }
                                setState(() {
                                  final paymentToMove = _pendingPayments
                                      .firstWhere(
                                        (p) => p['id'] == payment['id'],
                                      );
                                  _pendingPayments.remove(paymentToMove);
                                  paymentToMove['status'] = 'completed';
                                  _completedPayments.add(paymentToMove);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      message,
                                      style: GoogleFonts.afacad(),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please fill all required fields',
                                    style: GoogleFonts.afacad(),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8A4F7D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Confirm Payment',
                            style: GoogleFonts.afacad(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.afacad(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _showMpesaPinDialog(
    BuildContext context,
    Map<String, dynamic> payment,
    String phoneNumber,
  ) {
    final pinFormKey = GlobalKey<FormState>();
    final pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(
              'M-Pesa PIN',
              style: GoogleFonts.afacad(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8A4F7D),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your M-Pesa PIN for KSh ${payment['amount'].toStringAsFixed(2)} to "${payment['title']}"',
                  style: GoogleFonts.afacad(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: pinController,
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Iconsax.lock,
                      color: Color(0xFF8A4F7D),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your PIN';
                    }
                    if (!RegExp(r'^\d{4,6}$').hasMatch(value)) {
                      return 'PIN must be 4-6 digits';
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.afacad(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (pinFormKey.currentState!.validate()) {
                    // Simulate M-Pesa STK Push success
                    // In a real app, this would be handled by Daraja API webhook
                    setState(() {
                      final paymentToMove = _pendingPayments.firstWhere(
                        (p) => p['id'] == payment['id'],
                      );
                      _pendingPayments.remove(paymentToMove);
                      paymentToMove['status'] = 'completed';
                      _completedPayments.add(paymentToMove);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'M-Pesa payment successful for $phoneNumber.',
                          style: GoogleFonts.afacad(),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter a valid PIN',
                          style: GoogleFonts.afacad(),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4F7D),
                ),
                child: Text('Confirm', style: GoogleFonts.afacad()),
              ),
            ],
          ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Cancel Payment',
              style: GoogleFonts.afacad(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF44336),
              ),
            ),
            content: Text(
              'Are you sure you want to cancel your payment of KSh ${payment['amount'].toStringAsFixed(2)} for "${payment['title']}" on ${DateFormat('MMM dd, yyyy').format(payment['date'])}?',
              style: GoogleFonts.afacad(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'No, Keep It',
                  style: GoogleFonts.afacad(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Simulate cancellation
                  // For M-Pesa, use Reversal API: POST to /mpesa/reversal/v1/request
                  setState(() {
                    final paymentToMove = _pendingPayments.firstWhere(
                      (p) => p['id'] == payment['id'],
                    );
                    _pendingPayments.remove(paymentToMove);
                    paymentToMove['status'] = 'cancelled';
                    _completedPayments.add(paymentToMove);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Payment cancelled successfully',
                        style: GoogleFonts.afacad(),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                ),
                child: Text('Yes, Cancel', style: GoogleFonts.afacad()),
              ),
            ],
          ),
    );
  }
}
