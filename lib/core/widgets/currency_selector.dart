import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/currency.dart';
import '../providers/currency_provider.dart';
import '../theme/app_theme.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        return GestureDetector(
          onTap: () => _showCurrencyPicker(context, currencyProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.neonCyan.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currencyProvider.symbol,
                  style: const TextStyle(
                    color: AppColors.neonCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  currencyProvider.code,
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.mutedText,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyPicker(BuildContext context, CurrencyProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencyPickerSheet(
        selectedCurrency: provider.selectedCurrency,
        onCurrencySelected: (currency) {
          provider.setCurrency(currency);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class CurrencyPickerSheet extends StatelessWidget {
  final Currency selectedCurrency;
  final Function(Currency) onCurrencySelected;

  const CurrencyPickerSheet({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.mutedText.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.currency_exchange,
                  color: AppColors.neonCyan,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Currency',
                  style: TextStyle(
                    color: AppColors.lightText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.darkCard, height: 1),
          // Currency list
          SizedBox(
            height: 400,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: CurrencyData.all.length,
              itemBuilder: (context, index) {
                final currency = CurrencyData.all[index];
                final isSelected = currency == selectedCurrency;
                return _CurrencyTile(
                  currency: currency,
                  isSelected: isSelected,
                  onTap: () => onCurrencySelected(currency),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyTile({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.neonCyan.withValues(alpha: 0.2)
              : AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.neonCyan)
              : null,
        ),
        child: Center(
          child: Text(
            currency.symbol,
            style: TextStyle(
              color: isSelected ? AppColors.neonCyan : AppColors.lightText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        currency.name,
        style: TextStyle(
          color: isSelected ? AppColors.neonCyan : AppColors.lightText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        '${currency.code} • 1 ${currency.code} = ₹${currency.rateToInr.toStringAsFixed(2)}',
        style: const TextStyle(
          color: AppColors.mutedText,
          fontSize: 12,
        ),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.neonCyan,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.darkBackground,
                size: 16,
              ),
            )
          : null,
    );
  }
}
