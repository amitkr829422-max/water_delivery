// 5. ऑर्डर सफलतापूर्वक प्लेस होने की स्थिति
class OrderSuccessState extends CustomerState {}
import '../data/product_model.dart';

abstract class CustomerState {}

// 1. शुरुआती स्थिति (Initial State)
class CustomerInitial extends CustomerState {}

// 2. लोडिंग स्थिति (जब प्रोडक्ट्स Firestore से आ रहे हों - स्क्रीन पर Shimmer या Loading Shimmer दिखेगा)
class CustomerLoading extends CustomerState {}

// 3. डेटा लोड सक्सेस स्थिति (जब प्रोडक्ट्स सफलतापूर्वक मिल जाएं और लिस्ट स्क्रीन पर दिखानी हो)
class ProductsLoadedState extends CustomerState {
  final List<ProductModel> products;
  ProductsLoadedState({required this.products});
}

// 4. एरर स्थिति (अगर प्रोडक्ट्स लोड करने में कोई नेटवर्क या डेटाबेस एरर आए)
class CustomerErrorState extends CustomerState {
  final String errorMessage;
  CustomerErrorState({required this.errorMessage});
}
