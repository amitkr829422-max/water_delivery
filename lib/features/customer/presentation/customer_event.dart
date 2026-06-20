abstract class CustomerEvent {}

// 1. जब होम स्क्रीन खुलेगी, तब प्रोडक्ट्स लोड करने के लिए यह इवेंट ट्रिगर होगा
class LoadProductsEvent extends CustomerEvent {}
