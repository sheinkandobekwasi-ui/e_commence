import 'package:flutter/material.dart';
import 'package:hettys_shop/services/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// ============================================================================
/// AccountHelpdeskCard Widget
/// Coursework Concept: StatelessWidget / StatefulWidget, Container, child & children
/// ============================================================================
/// Provides a comprehensive 24/7 LIVE Customer Support card with active
/// url_launcher integrations:
/// 1. "Ask Query": Opens support inquiry view and saves ticket to Firestore
/// 2. "WhatsApp": Links directly to https://wa.me/233599876242 (0599876242)
/// 3. "Hotline": Links directly to tel:+233599876242
/// 4. Frequently asked questions covering Ghana delivery regions, Cedis payments,
///    and return policies with zero overflow warnings.
class AccountHelpdeskCard extends StatefulWidget {
  final VoidCallback? onQuerySubmitted;

  const AccountHelpdeskCard({super.key, this.onQuerySubmitted});

  @override
  State<AccountHelpdeskCard> createState() => _AccountHelpdeskCardState();
}

class _AccountHelpdeskCardState extends State<AccountHelpdeskCard> {
  bool _isExpanded = false;

  Future<void> _launchWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/233599876242');
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WhatsApp: +233 59 987 6242 (0599876242)'),
            backgroundColor: Color(0xFF25D366),
          ),
        );
      }
    }
  }

  Future<void> _launchHotline(BuildContext context) async {
    final uri = Uri.parse('tel:+233599876242');
    try {
      final launched = await launchUrl(uri);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hotline: 0599876242 (+233 59 987 6242)'),
            backgroundColor: Color(0xFF2575FC),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hotline: 0599876242 (+233 59 987 6242)'),
            backgroundColor: Color(0xFF2575FC),
          ),
        );
      }
    }
  }

  void _showQueryDialog(BuildContext context) {
    final queryController = TextEditingController();
    String selectedTopic = 'Delivery & Tracking';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.88,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A11CB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.support_agent_rounded,
                        color: Color(0xFF6A11CB),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Query Resolution',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Submit your request for fast resolution',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Query Category',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedTopic,
                  isDense: true,
                  menuMaxHeight: 250,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Delivery & Tracking',
                      child: Text('Delivery & Tracking (16 Ghana Regions)'),
                    ),
                    DropdownMenuItem(
                      value: 'Payment & Cedis (GH₵)',
                      child: Text('Payment & Mobile Money (GH₵)'),
                    ),
                    DropdownMenuItem(
                      value: 'Product Quality & Specs',
                      child: Text('Product Specifications & Quality'),
                    ),
                    DropdownMenuItem(
                      value: 'Returns & Exchange',
                      child: Text('Returns, Refund & Exchange'),
                    ),
                    DropdownMenuItem(
                      value: 'Other Account Help',
                      child: Text('Other Account / Customer Inquiry'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() {
                        selectedTopic = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Describe your question or issue',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: queryController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'e.g. Please confirm delivery timeline to Kumasi, Ashanti Region...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final text = queryController.text.trim();
                      if (text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please describe your query first.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      final ticketNumber =
                          'TKT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

                      // Hybrid Storage Logic: Sync Support Inquiry to Firestore
                      FirebaseService().saveSupportTicket({
                        'ticketNumber': ticketNumber,
                        'topic': selectedTopic,
                        'query': text,
                        'createdAt': DateTime.now().toLocal().toString(),
                      });

                      Navigator.pop(ctx);

                      showDialog(
                        context: context,
                        builder: (alertCtx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          title: Row(
                            children: const [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text('Ticket Created!'),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ticket Number: $ticketNumber',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6A11CB),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Topic: $selectedTopic\n\nYour query has been dispatched to Shei Store customer support & synced to Firestore. A representative will contact you via phone or email shortly.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(alertCtx),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6A11CB),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );

                      if (widget.onQuerySubmitted != null) {
                        widget.onQuerySubmitted!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A11CB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Support Ticket',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
  ),
);
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF6A11CB).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A11CB).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.headset_mic_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'Account Helpdesk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: const Text(
                            '24/7 LIVE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Instant help with Cedis orders & delivery across Ghana',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quick Action Channels Row
          Row(
            children: [
              // Live Query button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showQueryDialog(context),
                  icon: const Icon(Icons.edit_note_rounded, size: 16),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Ask Query',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A11CB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // WhatsApp Help button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchWhatsApp(context),
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: Color(0xFF25D366),
                  ),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'WhatsApp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Call Hotline button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchHotline(context),
                  icon: const Icon(
                    Icons.phone_in_talk_outlined,
                    size: 16,
                    color: Color(0xFF2575FC),
                  ),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Hotline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Collapsible FAQ Accordion for quick resolution
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _isExpanded
                          ? 'Hide Common Solutions'
                          : 'View Instant FAQ Solutions (Ghana Delivery & Payments)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(height: 16),
            _buildFaqItem(
              'Delivery in Ghana (16 Regions)',
              'Greater Accra & Ashanti: Same-day / 24h. All other 14 regions: 1-2 business days with SMS package tracking.',
            ),
            const SizedBox(height: 8),
            _buildFaqItem(
              'Currency & Payment Methods',
              'Exclusively Ghana Cedis (GH₵). We accept Cash on Delivery, MTN MoMo, Telecel Cash, and Visa/Mastercard.',
            ),
            const SizedBox(height: 8),
            _buildFaqItem(
              '7-Day Return & Cedis Refund',
              'Enjoy 7-day returns for size swaps or defects. Refunds processed in Ghana Cedis directly to your MoMo number.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFaqItem(String title, String answer) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 14,
                color: Color(0xFF6A11CB),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
