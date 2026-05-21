import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';
import '../models/address_model.dart';
import '../core/app_snack_bar.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  bool _isAddingNew = false;

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<AddressProvider>().fetchAddresses(authProvider.user!.uid);
      }
    });
  }

  void _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final addressProvider = context.read<AddressProvider>();

    if (!authProvider.isAuthenticated) {
      AppSnackBar.showError(context, 'You must be logged in to save an address.');
      return;
    }

    final address = Address(
      id: const Uuid().v4(),
      userId: authProvider.user!.uid, // Pass userId
      name: _nameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      zipCode: _zipController.text.trim(),
      country: 'India',
    );

    await addressProvider.addAddress(authProvider.user!.uid, address);
    addressProvider.selectAddress(address);
    
    if (!mounted) return;
    AppSnackBar.showSuccess(context, 'Address added successfully!');
    setState(() {
      _isAddingNew = false;
      _nameController.clear();
      _streetController.clear();
      _cityController.clear();
      _zipController.clear();
    });
  }

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
          'Personal Details',
          style: TextStyle(
            color: Color(0xFF1F1B16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer2<AddressProvider, AuthProvider>(
        builder: (context, addressProvider, authProvider, child) {
          if (addressProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF7A5136)));
          }

          final addresses = addressProvider.addresses;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved Addresses',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F1B16),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Select your preferred delivery point',
                            style: TextStyle(fontSize: 14, color: Color(0xFF51443D)),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => setState(() => _isAddingNew = !_isAddingNew),
                        icon: Icon(
                          _isAddingNew ? Icons.close : Icons.add_circle_outline,
                          color: const Color(0xFF7A5136),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  if (_isAddingNew) ...[
                    _buildAddressForm(),
                    const SizedBox(height: 48),
                    const Divider(color: Color(0xFFF1E6DD)),
                    const SizedBox(height: 24),
                  ],

                  if (addresses.isEmpty && !_isAddingNew)
                    _buildEmptyState()
                  else
                    ...addresses.map((address) => _buildAddressCard(address, addressProvider, authProvider)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildInputField(
            label: 'Full Name',
            hint: 'Julianne Moore',
            controller: _nameController,
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Street Address',
            hint: '1248 Silk Avenue, Penthouse B',
            controller: _streetController,
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'City',
                  hint: 'Mumbai',
                  controller: _cityController,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  label: 'Postal Code',
                  hint: '400001',
                  controller: _zipController,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A5136),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              onPressed: _saveAddress,
              child: const Text(
                'ADD THIS ADDRESS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.location_on_outlined, size: 64, color: const Color(0xFFD5C3B9).withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              'No saved addresses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1B16),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first address to proceed with checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF51443D)),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => setState(() => _isAddingNew = true),
              child: const Text(
                'Add New Address',
                style: TextStyle(color: Color(0xFF7A5136), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Address address, AddressProvider provider, AuthProvider auth) {
    final isSelected = provider.selectedAddress?.id == address.id;

    return GestureDetector(
      onTap: () => provider.selectAddress(address),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8F4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF7A5136) : const Color(0xFFF1E6DD),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF7A5136).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF7A5136) : const Color(0xFFFDF2E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.location_on_outlined,
                color: isSelected ? Colors.white : const Color(0xFF7A5136),
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1F1B16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${address.street}, ${address.city}',
                    style: const TextStyle(color: Color(0xFF51443D), fontSize: 14),
                  ),
                  Text(
                    '${address.zipCode}, ${address.country}',
                    style: const TextStyle(color: Color(0xFF83746C), fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!isSelected)
              IconButton(
                onPressed: () => provider.removeAddress(auth.user!.uid, address.id),
                icon: const Icon(Icons.delete_outline, color: Color(0xFFBA1A1A), size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Color(0xFF51443D),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDF2E9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFD5C3B9)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
