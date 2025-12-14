import 'package:flutter/material.dart';
import '../models/currency.dart';

class CurrencyProvider extends ChangeNotifier {
  Currency _selectedCurrency = CurrencyData.inr;

  Currency get selectedCurrency => _selectedCurrency;
  String get symbol => _selectedCurrency.symbol;
  String get code => _selectedCurrency.code;

  void setCurrency(Currency currency) {
    if (_selectedCurrency != currency) {
      _selectedCurrency = currency;
      notifyListeners();
    }
  }

  // Format amount with currency symbol
  String format(double amount, {int decimals = 2}) {
    final formatted = amount.toStringAsFixed(decimals);
    // Add thousand separators
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    if (parts.length > 1) {
      return '$symbol$intPart.${parts[1]}';
    }
    return '$symbol$intPart';
  }

  // Convert amount from INR to selected currency
  double convertFromInr(double inrAmount) {
    return _selectedCurrency.fromInr(inrAmount);
  }

  // Convert amount from selected currency to INR
  double convertToInr(double amount) {
    return _selectedCurrency.toInr(amount);
  }

  // Format amount that's stored in INR to selected currency
  String formatFromInr(double inrAmount, {int decimals = 2}) {
    final converted = convertFromInr(inrAmount);
    return format(converted, decimals: decimals);
  }
}
