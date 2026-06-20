import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/constants/colors.dart';
import 'customer_bloc.dart';
import 'customer_event.dart';
import 'customer_state.dart';
import '../data/product_model.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final Map<String, int> _cartQuantities = {};
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(LoadProductsEvent());
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // कुल आइटम और टोटल अमाउंट कैलकुलेट करने का फ़ंक्शन
  double _calculateTotal(List<ProductModel> products) {
    double total = 0;
    _cartQuantities.forEach((productId, qty) {
      final product = products.firstWhere((p) => p.id == productId);
      total += product.price * qty;
    });
    return total;
  }

  int _totalItemsCount() {
    return _cartQuantities.values.fold(0, (sum, item) => sum + item);
  }

  // ऑर्डर प्लेस करने के लिए बॉटम शीट (रसीद) दिखाने का फ़ंक्शन
  void _showOrderBottomSheet(BuildContext context, List<ProductModel> loadedProducts, double totalAmount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ऑर्डर की समीक्षा (Summary)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // चुने गए आइटम्स की लिस्ट
              ...loadedProducts.where((p) => (_cartQuantities[p.id] ?? 0) > 0).map((product) {
                final qty = _cartQuantities[product.id]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product.name} (x$qty)', style: const TextStyle(fontSize: 15)),
                      Text('₹${product.price * qty}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('कुल राशि (Total Amount):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('₹$totalAmount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold, color: AppColors.primaryLight)),
                ],
              ),
              const SizedBox(height: 20),
              // डिलीवरी एड्रेस इनपुट
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'डिलीवरी का पूरा पता दर्ज करें',
                  prefixIcon: const Icon(Icons.home_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              // फाइनल कन्फर्म बटन
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_addressController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('कृपया डिलीवरी का पता दर्ज करें!'), backgroundColor: AppColors.error),
                        );
                        return;
                      }

                      // आइटम्स का मैप तैयार करना बैकएंड के लिए
                      final orderItems = loadedProducts
                          .where((p) => (_cartQuantities[p.id] ?? 0) > 0)
                          .map((p) => {
                                'productId': p.id,
                                'name': p.name,
                                'quantity': _cartQuantities[p.id],
                                'price': p.price,
                              })
                          .toList();

                      // ब्लौक में इवेंट भेजना
                      context.read<CustomerBloc>().add(PlaceOrderEvent(
                            items: orderItems,
                            totalAmount: totalAmount,
                            deliveryAddress: _addressController.text.trim(),
                          ));

                      Navigator.pop(bottomSheetContext); // बॉटम शीट बंद करें
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('ऑर्डर पक्का करें (Confirm Order)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state declaration OrderSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 आपका ऑर्डर सफलतापूर्वक दर्ज हो गया है!'), backgroundColor: Colors.green),
            );
            setState(() {
              _cartQuantities.clear(); // ऑर्डर होने के बाद कार्ट खाली कर दें
              _addressController.clear();
            });
          } else if (state declaration CustomerErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          List<ProductModel> currentProducts = [];

          if (state declaration CustomerLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryLight));
          } else if (state declaration ProductsLoadedState) {
            currentProducts = state.products;
          }

          if (currentProducts.isEmpty && state declaration! CustomerLoading) {
            return const Center(child: Text('वर्तमान में कोई प्रोडक्ट उपलब्ध नहीं है।'));
          }

          final totalAmount = _calculateTotal(currentProducts);
          final itemsCount = _totalItemsCount();

          return Column(
            children: [
              // डिलीवरी लोकेशन हेडर
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
                          Text('Delivery To', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight.withOpacity(0.6))),
                          const Text('Kariho, Bihar, India', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // प्रोडक्ट्स लिस्टिंग
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: currentProducts.length,
                  itemBuilder: (context, index) {
                    final product = currentProducts[index];
                    final currentQty = _cartQuantities[product.id] ?? 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.water_drop, size: 40, color: AppColors.primaryLight),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('₹${product.price}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: AppColors.primaryLight)),
                                ],
                              ),
                            ),
                            // काउंटर
                            Container(
                              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.primaryLight),
                                    onPressed: currentQty > 0 ? () => setState(() => _cartQuantities[product.id] = currentQty - 1) : null,
                                  ),
                                  Text('$currentQty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_rounded, color: AppColors.primaryLight),
                                    onPressed: () => setState(() => _cartQuantities[product.id] = currentQty + 1),
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

              // अगर कार्ट में आइटम है, तो नीचे बास्केट बार दिखाएं
              if (itemsCount > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$itemsCount Items Selected', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            Text('₹$totalAmount', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.extrabold, color: AppColors.primaryLight)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => _showOrderBottomSheet(context, currentProducts, totalAmount),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('आगे बढ़ें (Proceed)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

