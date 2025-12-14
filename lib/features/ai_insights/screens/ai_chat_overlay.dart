import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AiChatOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const AiChatOverlay({super.key, required this.onClose});

  @override
  State<AiChatOverlay> createState() => _AiChatOverlayState();
}

class _AiChatOverlayState extends State<AiChatOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Add welcome message
    _messages.add(ChatMessage(
      text: "Hi! I'm your AI financial assistant. How can I help you today?",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _closeOverlay() async {
    await _controller.reverse();
    widget.onClose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _getAiResponse(text),
            isUser: false,
          ));
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  String _getAiResponse(String input) {
    final lowered = input.toLowerCase();
    if (lowered.contains('expense') || lowered.contains('spending')) {
      return "I can help you track your expenses! Go to the Expenses tab to add new transactions or view your spending history.";
    } else if (lowered.contains('goal') || lowered.contains('save')) {
      return "Setting financial goals is a great idea! Head to the Goals tab to create and track your savings targets.";
    } else if (lowered.contains('analytics') || lowered.contains('report')) {
      return "Check out the Analytics tab for detailed insights into your spending patterns and financial health.";
    } else if (lowered.contains('hello') || lowered.contains('hi')) {
      return "Hello! I'm here to help you manage your finances better. What would you like to know?";
    }
    return "I'm here to help with your financial queries. You can ask me about expenses, savings goals, or financial analytics!";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Background overlay
            GestureDetector(
              onTap: _closeOverlay,
              child: Container(
                color: Colors.black.withValues(alpha: _fadeAnimation.value * 0.7),
              ),
            ),
            // Chat panel
            Positioned(
              bottom: 100,
              right: 16,
              left: 16,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                alignment: Alignment.bottomRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.neonCyan.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonCyan.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.neonCyan.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.neonCyan,
                                    AppColors.neonPurple,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neonCyan.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.psychology,
                                color: AppColors.darkBackground,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'FinMitra AI',
                                    style: TextStyle(
                                      color: AppColors.lightText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.neonGreen,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.neonGreen.withValues(alpha: 0.5),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Online',
                                        style: TextStyle(
                                          color: AppColors.mutedText,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _closeOverlay,
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Messages
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
                      ),
                      // Input field
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.neonCyan.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                style: const TextStyle(color: AppColors.lightText),
                                decoration: InputDecoration(
                                  hintText: 'Ask me anything...',
                                  hintStyle: const TextStyle(color: AppColors.mutedText),
                                  filled: true,
                                  fillColor: AppColors.darkCard,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _sendMessage,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.neonCyan,
                                      AppColors.neonBlue,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.neonCyan.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: AppColors.darkBackground,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.neonCyan, AppColors.neonPurple],
                ),
              ),
              child: const Icon(
                Icons.psychology,
                color: AppColors.darkBackground,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.neonCyan.withValues(alpha: 0.2)
                    : AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: message.isUser
                    ? Border.all(
                        color: AppColors.neonCyan.withValues(alpha: 0.5),
                      )
                    : null,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? AppColors.neonCyan : AppColors.lightText,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
