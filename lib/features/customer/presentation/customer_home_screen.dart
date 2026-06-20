import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/constants/colors.dart';
import 'customer_bloc.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  // हर प्रोडक्ट की क्वांटिटी ट्रैक करने के लिए एक मैप (ProductId -> Quantity)
  final Map<String, int> _cartQuantities = {};

  @override
  void initState() {
    super.initState();
    // स्क्रीन खुलते ही प्रोडक्ट्स लोड करने के लिए इवेंट ट्रिगर करना
    context.read<CustomerBloc>().add(LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Water Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight),
            );
          } else if (state is CustomerErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: AppColors.error, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (state is ProductsLoadedState) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text('वर्तमान में कोई प्रोडक्ट उपलब्ध नहीं है।'),
              );
            }

            return Column(
              children: [
                // ऊपर का वेलकम और एड्रेस बैनर
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primaryLight),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery To',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight.withOpacity(0.6)),
                            ),
                            const Text(
                              'कृपया अपना डिलीवरी पता चुनें',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // प्रोडक्ट्स की लिस्ट
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      final currentQty = _cartQuantities[product.id] ?? 0;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        shadowColor: Colors.black10,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // प्रोडक्ट इमेज के लिए कंटेनर
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: product.imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(product.imageUrl, fit: BoxFit.cover),
                                      )
                                    : const Icon(Icons.water_drop, size: 40, color: AppColors.primaryLight),
                              ),
                              const SizedBox(width: 16),

                              // नाम और कीमत की डिटेल्स
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.description,
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight.withOpacity(0.7)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₹${product.price}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: AppColors.primaryLight),
                                    ),
                                  ],
                                ),
                              ),

                              // प्लस-माइनस क्वांटिटी काउंटर
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.primaryLight),
                                      onPressed: currentQty > 0
                                          ? () {
                                              setState(() {
                                                _cartQuantities[product.id] = currentQty - 1;
                                              });
                                            }
                                          : null,
                                    ),
                                    Text(
                                      '$currentQty',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_rounded, color: AppColors.primaryLight),
                                      onPressed: () {
                                        setState(() {
                                          _cartQuantities[product.id] = currentQty + 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
