import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import '../theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 1;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final cardCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    zipCtrl.dispose();
    cardCtrl.dispose();
    expiryCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      // Complete purchase
      context.read<CartProvider>().clearCart();
      context.go('/library');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _step > 1 ? setState(() => _step--) : context.pop(),
        ),
        title: Text('Checkout (Step $_step/3)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i + 1 <= _step ? AppTheme.accent : AppTheme.muted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStep(),
              ),
            ),
            CustomButton(
              label: _step == 3 ? 'Complete Purchase' : 'Continue',
              variant: ButtonVariant.secondary,
              isFullWidth: true,
              onPressed: _next,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1:
        return Column(
          key: const ValueKey(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Information', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            CustomInput(label: 'Full Name', controller: nameCtrl),
            CustomInput(label: 'Email', controller: emailCtrl, keyboardType: TextInputType.emailAddress),
            CustomInput(label: 'Address', controller: addressCtrl),
            Row(
              children: [
                Expanded(child: CustomInput(label: 'City', controller: cityCtrl)),
                const SizedBox(width: 12),
                Expanded(child: CustomInput(label: 'ZIP Code', controller: zipCtrl)),
              ],
            ),
          ],
        );
      case 2:
        return Column(
          key: const ValueKey(2),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Method', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            CustomInput(label: 'Card Number', controller: cardCtrl, placeholder: '1234 5678 9012 3456'),
            Row(
              children: [
                Expanded(child: CustomInput(label: 'Expiry', controller: expiryCtrl, placeholder: 'MM/YY')),
                const SizedBox(width: 12),
                Expanded(child: CustomInput(label: 'CVV', controller: cvvCtrl, placeholder: '123')),
              ],
            ),
          ],
        );
      case 3:
        return Card(
          key: const ValueKey(3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Review Order', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text('Shipping to:', style: TextStyle(color: Colors.grey[600])),
                Text(nameCtrl.text),
                Text('${addressCtrl.text}, ${cityCtrl.text} ${zipCtrl.text}'),
                const Divider(height: 24),
                Text('Payment:', style: TextStyle(color: Colors.grey[600])),
                Text('Card ending in ${cardCtrl.text.isNotEmpty ? cardCtrl.text.substring(cardCtrl.text.length - 4) : '****'}'),
              ],
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}