import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/widgets/currency_selector.dart';
import '../../expenses/screens/expenses_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../goals/screens/goals_screen.dart';
import '../../ai_insights/screens/ai_chat_overlay.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showAiChat = false;

  late AnimationController _fabController;
  late Animation<double> _fabRotation;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    ExpensesScreen(),
    AnalyticsScreen(),
    GoalsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleAiChat() {
    setState(() {
      _showAiChat = !_showAiChat;
      if (_showAiChat) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.neonCyan.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: AppColors.neonCyan,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'FinMitra',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
        actions: const [
          CurrencySelector(),
          SizedBox(width: 16),
        ],
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          if (_showAiChat)
            AiChatOverlay(
              onClose: _toggleAiChat,
            ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_showAiChat ? AppColors.neonPink : AppColors.neonCyan)
                      .withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: _toggleAiChat,
              backgroundColor:
                  _showAiChat ? AppColors.neonPink : AppColors.neonCyan,
              child: RotationTransition(
                turns: _fabRotation,
                child: Icon(
                  _showAiChat ? Icons.close : Icons.psychology,
                  color: AppColors.darkBackground,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.neonCyan.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedIndex,
          backgroundColor: AppColors.darkSurface,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.attach_money),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              selectedIcon: Icon(Icons.flag),
              label: 'Goals',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  // Sample data stored in INR (base currency)
  static const double _balanceInr = 1052025.00; // ~$12,450 in INR
  static const double _incomeInr = 354900.00;   // ~$4,200 in INR
  static const double _expensesInr = 156325.00; // ~$1,850 in INR

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Here\'s your financial overview',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 24),
              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.neonCyan.withValues(alpha: 0.2),
                      AppColors.neonPurple.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.neonCyan.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyProvider.formatFromInr(_balanceInr),
                      style: const TextStyle(
                        color: AppColors.lightText,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatItem(
                          'Income',
                          '+${currencyProvider.formatFromInr(_incomeInr)}',
                          AppColors.neonGreen,
                          Icons.arrow_upward,
                        ),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          'Expenses',
                          '-${currencyProvider.formatFromInr(_expensesInr)}',
                          AppColors.neonPink,
                          Icons.arrow_downward,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightText,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildQuickAction(
                    'Add Expense',
                    Icons.remove_circle_outline,
                    AppColors.neonPink,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    'Add Income',
                    Icons.add_circle_outline,
                    AppColors.neonGreen,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    'Transfer',
                    Icons.swap_horiz,
                    AppColors.neonBlue,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.lightText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
