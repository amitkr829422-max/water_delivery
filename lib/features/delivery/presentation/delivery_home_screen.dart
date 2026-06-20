import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/constants/colors.dart';
import 'delivery_bloc.dart';
import 'delivery_event.dart';
import 'delivery_state.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  @override
  void initState() {
    super.initState();
    // स्क्रीन लोड होते ही पेंडिंग ऑर्डर्स फ़ेच करना
    context.read<DeliveryBloc>().add(LoadPendingOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Delivery Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<DeliveryBloc>().add(LoadPendingOrdersEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<DeliveryBloc, DeliveryState>(
        listener: (context, state) {
          if (state is OrderMarkedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🎉 ऑर्डर सफलतापूर्वक डिलीवर मार्क कर दिया गया है!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DeliveryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DeliveryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight),
            );
          } else if (state is PendingOrdersLoadedState) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_turned_in_rounded, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      'कोई पेंडिंग ऑर्डर नहीं है!\nसब कुछ डिलीवर हो चुका है।',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ऑर्डर ID और स्टेटस हेडर
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID: #${order.id.substring(0, 6).toUpperCase()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.status.toUpperCase(),
                                style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        // डिलीवरी का पता
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_rounded, color: AppColors.primaryLight, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Delivery Address:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 2),
                                  Text(
                                    order.deliveryAddress,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // आइटम्स की लिस्ट (क्या-क्या डिलीवर करना है)
                        const Text('Items:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        ...order.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item['name']} × ${item['quantity']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text('₹${item['price'] * item['quantity']}', style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          );
                        }),
                        const Divider(height: 24),

                        // टोटल अमाउंट और एक्शन बटन
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Cash to Collect:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                Text(
                                  '₹${order.totalAmount}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold, color: AppColors.primaryLight),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<DeliveryBloc>().add(MarkDeliveredEvent(orderId: order.id));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                              label: const Text('Mark Delivered', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
