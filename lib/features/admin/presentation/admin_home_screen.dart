import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/constants/colors.dart';
import '../../customer/data/product_model.dart';
import '../../customer/presentation/customer_bloc.dart';
import '../../customer/presentation/customer_event.dart';
import '../../customer/presentation/customer_state.dart';
import 'admin_bloc.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    // स्क्रीन लोड होते ही प्रोडक्ट्स की लिस्ट लोड करना
    context.read<CustomerBloc>().add(LoadProductsEvent());
  }

  // प्रोडक्ट ऐड या एडिट करने के लिए डायलॉग बॉक्स (Bottom Sheet)
  void _showProductForm({ProductModel? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price != null ? product!.price.toString() : '');
    bool isAvailable = product?.isAvailable ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product == null ? '➕ Add New Product' : '✏️ Edit Product',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name (e.g., 20L Water Jar)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price (₹)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Available in Stock'),
                    value: isAvailable,
                    activeColor: AppColors.primaryLight,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setModalState(() {
                        isAvailable = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (nameController.text.isEmpty || priceController.text.isEmpty) {
                          return;
                        }

                        final double? price = double.tryParse(priceController.text);
                        if (price == null) return;

                        final newProduct = ProductModel(
                          id: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text,
                          price: price,
                          isAvailable: isAvailable,
                        );

                        if (product == null) {
                          // Add Product Event
                          BlocProvider.of<AdminBloc>(context).add(AdminAddProductEvent(product: newProduct));
                        } else {
                          // Update Product Event
                          BlocProvider.of<AdminBloc>(context).add(AdminUpdateProductEvent(product: newProduct));
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        product == null ? 'Save Product' : 'Update Product',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<CustomerBloc>().add(LoadProductsEvent());
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state is AdminLoading) {
                // आप चाहें तो लोडिंग इंडिकेटर दिखा सकते हैं
              } else if (state is AdminActionSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                );
                // एडमिन एक्शन सक्सेस होने के बाद लिस्ट को दोबारा रिफ्रेश करना
                context.read<CustomerBloc>().add(LoadProductsEvent());
              } else if (state is AdminErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage), backgroundColor: AppColors.error),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is ProductsLoadingState) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryLight));
            } else if (state is ProductsLoadedState) {
              final products = state.products;

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.layers_clear_rounded, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text(
                        'कोई प्रोडक्ट उपलब्ध नहीं है!\nनीचे दिए गए बटन से नया प्रोडक्ट जोड़ें।',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                        child: const Icon(Icons.water_drop_rounded, color: AppColors.primaryLight),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Row(
                        children: [
                          Text('₹${product.price}', style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: product.isAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.isAvailable ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(color: product.isAvailable ? Colors.green : Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                            onPressed: () => _showProductForm(product: product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                            onPressed: () {
                              // डिलीट कन्फर्मेशन डायलॉग
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Product?'),
                                  content: Text('क्या आप सच में "${product.name}" को हटाना चाहते हैं?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                    TextButton(
                                      onPressed: () {
                                        context.read<AdminBloc>().add(AdminDeleteProductEvent(productId: product.id));
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductsErrorState) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _showProductForm(),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
