import 'package:flutter/material.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A5136)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Details',
          style: TextStyle(
            color: Color(0xFF1F1B16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Methods',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1B16),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage your preferred payment options.',
                style: TextStyle(fontSize: 14, color: Color(0xFF51443D)),
              ),
              const SizedBox(height: 32),
              _buildDemoCard(),
              const SizedBox(height: 32),
              const Text(
                'Add New Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1B16),
                ),
              ),
              const SizedBox(height: 16),
              _buildAddPaymentOption(
                icon: Icons.credit_card,
                label: 'Credit or Debit Card',
              ),
              const SizedBox(height: 12),
              _buildAddPaymentOption(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Digital Wallet (Apple/Google Pay)',
              ),
              const SizedBox(height: 48),
              const Center(
                child: Text(
                  'Your payment information is encrypted and secure.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF83746C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7A5136), Color(0xFF96694C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A5136).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.contactless, color: Colors.white, size: 32),
              Text(
                'PREMIUM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const Text(
            '**** **** **** 4242',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'JULIANNE MOORE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '12/28',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddPaymentOption({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD5C3B9).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEBE1D8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF7A5136)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1B16),
              ),
            ),
          ),
          const Icon(Icons.add_circle_outline, color: Color(0xFFD5C3B9)),
        ],
      ),
    );
  }
}
