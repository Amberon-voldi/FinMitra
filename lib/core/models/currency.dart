class Currency {
  final String code;
  final String symbol;
  final String name;
  final double rateToInr; // Conversion rate: 1 unit of this currency = X INR

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.rateToInr,
  });

  // Convert amount from this currency to INR
  double toInr(double amount) => amount * rateToInr;

  // Convert amount from INR to this currency
  double fromInr(double amount) => amount / rateToInr;

  // Convert amount from this currency to another currency
  double convertTo(double amount, Currency target) {
    final inrAmount = toInr(amount);
    return target.fromInr(inrAmount);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class CurrencyData {
  static const Currency inr = Currency(
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupee',
    rateToInr: 1.0,
  );

  static const Currency usd = Currency(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    rateToInr: 84.50, // 1 USD = 84.50 INR (approximate)
  );

  static const Currency eur = Currency(
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
    rateToInr: 89.20, // 1 EUR = 89.20 INR (approximate)
  );

  static const Currency gbp = Currency(
    code: 'GBP',
    symbol: '£',
    name: 'British Pound',
    rateToInr: 107.50, // 1 GBP = 107.50 INR (approximate)
  );

  static const Currency jpy = Currency(
    code: 'JPY',
    symbol: '¥',
    name: 'Japanese Yen',
    rateToInr: 0.56, // 1 JPY = 0.56 INR (approximate)
  );

  static const Currency aed = Currency(
    code: 'AED',
    symbol: 'د.إ',
    name: 'UAE Dirham',
    rateToInr: 23.01, // 1 AED = 23.01 INR (approximate)
  );

  static const Currency cad = Currency(
    code: 'CAD',
    symbol: 'C\$',
    name: 'Canadian Dollar',
    rateToInr: 59.80, // 1 CAD = 59.80 INR (approximate)
  );

  static const Currency aud = Currency(
    code: 'AUD',
    symbol: 'A\$',
    name: 'Australian Dollar',
    rateToInr: 54.30, // 1 AUD = 54.30 INR (approximate)
  );

  static const Currency sgd = Currency(
    code: 'SGD',
    symbol: 'S\$',
    name: 'Singapore Dollar',
    rateToInr: 62.80, // 1 SGD = 62.80 INR (approximate)
  );

  static const Currency chf = Currency(
    code: 'CHF',
    symbol: 'Fr',
    name: 'Swiss Franc',
    rateToInr: 95.20, // 1 CHF = 95.20 INR (approximate)
  );

  static List<Currency> get all => [
        inr,
        usd,
        eur,
        gbp,
        jpy,
        aed,
        cad,
        aud,
        sgd,
        chf,
      ];

  static Currency getByCode(String code) {
    return all.firstWhere(
      (c) => c.code == code,
      orElse: () => inr,
    );
  }
}
