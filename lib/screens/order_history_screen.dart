import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_toggle_button.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.orderHistory),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          const LanguageToggleButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            final localizations = AppLocalizations.of(context)!;
            return Center(
              child: Text(localizations.isBengali 
                ? 'অর্ডার লোড করতে ত্রুটি: ${snapshot.error}'
                : 'Error loading orders: ${snapshot.error}'),
            );
          }
          
          final orders = snapshot.data ?? [];
          return orders.isEmpty
              ? _buildEmptyHistory()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, order);
                  },
                );
        },
      ),
    );
  }

  Widget _buildEmptyHistory() {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            localizations.isBengali ? 'কোন অর্ডার ইতিহাস নেই' : 'No order history',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.isBengali 
              ? 'আপনার পূর্বের অর্ডারগুলি এখানে দেখা যাবে'
              : 'Your past orders will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.isBengali 
                  ? 'অর্ডার ${order.id}'
                  : 'Order ${order.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              _buildStatusChip(order.status),
            ],
          ),
          const SizedBox(height: 8),
          
          // Order Date
          Text(
            AppLocalizations.of(context)!.isBengali 
              ? 'অর্ডার করা হয়েছে ${_formatDate(order.orderDate)}'
              : 'Ordered on ${_formatDate(order.orderDate)}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Order Summary
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  AppLocalizations.of(context)!.isBengali ? 'আইটেম' : 'Items',
                  '${order.items.length}',
                  Icons.shopping_bag_outlined,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  AppLocalizations.of(context)!.isBengali ? 'মোট' : 'Total',
                  '${AppLocalizations.of(context)!.currency}${order.totalAmount.toStringAsFixed(0)}',
                  Icons.attach_money,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showOrderDetails(context, order),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.isBengali ? 'বিস্তারিত দেখুন' : 'View Details',
                    style: const TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: order.status == 'delivered'
                      ? () => _showReorderDialog(context, order)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.isBengali ? 'পুনরায় অর্ডার' : 'Reorder'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    
    String displayStatus = status;
    final localizations = AppLocalizations.of(context)!;
    
    if (localizations.isBengali) {
      switch (status.toLowerCase()) {
        case 'delivered':
          displayStatus = 'ডেলিভার হয়েছে';
          break;
        case 'in transit':
          displayStatus = 'পথে আছে';
          break;
        case 'processing':
          displayStatus = 'প্রক্রিয়াকরণ';
          break;
        default:
          displayStatus = status;
      }
    }
    
    switch (status.toLowerCase()) {
      case 'delivered':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'in transit':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case 'processing':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF2E7D32),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    
    if (localizations.isBengali) {
      final months = [
        'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
        'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.isBengali ? 'অর্ডার ${order.id}' : 'Order ${order.id}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(localizations.isBengali 
                  ? 'তারিখ: ${_formatDate(order.orderDate)}'
                  : 'Date: ${_formatDate(order.orderDate)}'),
                Text(localizations.isBengali 
                  ? 'অবস্থা: ${_getLocalizedStatus(order.status)}'
                  : 'Status: ${order.status}'),
                const SizedBox(height: 16),
                Text(
                  localizations.isBengali ? 'পণ্যসমূহ:' : 'Products:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order.items.map<Widget>((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• ${item.name} (${item.quantity}x) - ${localizations.currency}${item.price.toStringAsFixed(0)}',
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Text(
                  localizations.isBengali 
                    ? 'মোট: ${localizations.currency}${order.totalAmount.toStringAsFixed(0)}'
                    : 'Total: ${localizations.currency}${order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.isBengali ? 'বন্ধ করুন' : 'Close'),
            ),
          ],
        );
      },
    );
  }

  void _showReorderDialog(BuildContext context, OrderModel order) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.isBengali ? 'পুনরায় অর্ডার' : 'Reorder'),
          content: Text(localizations.isBengali 
            ? 'আপনি কি অর্ডার ${order.id} থেকে পণ্যগুলি পুনরায় অর্ডার করতে চান?'
            : 'Would you like to reorder the items from Order ${order.id}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.isBengali 
                      ? 'পুনরায় অর্ডার করার সুবিধা শীঘ্রই আসছে!'
                      : 'Reorder functionality coming soon!'),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: Text(localizations.isBengali ? 'পুনরায় অর্ডার' : 'Reorder'),
            ),
          ],
        );
      },
    );
  }
  
  String _getLocalizedStatus(String status) {
    final localizations = AppLocalizations.of(context)!;
    if (!localizations.isBengali) return status;
    
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'ডেলিভার হয়েছে';
      case 'in transit':
        return 'পথে আছে';
      case 'processing':
        return 'প্রক্রিয়াকরণ';
      default:
        return status;
    }
  }
}
