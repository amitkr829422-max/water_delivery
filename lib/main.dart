import 'package:flutter/material.dart';
import 'app/config/theme.dart';

void main() {
  // सुनिश्चित करें कि फ़्लटर इंजन बाइंडिंग्स ठीक से इनिशियलाइज़ हो गई हैं
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const WaterDeliveryApp());
}

class WaterDeliveryApp extends StatelessWidget {
  const WaterDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Delivery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // फ़ोन की सेटिंग के हिसाब से लाइट/डार्क मोड खुद बदल जाएगा
      home: const InitializationPlaceholder(),
    );
  }
}

// यह एक अस्थायी स्क्रीन है जब तक हम अगले मॉड्यूल में स्प्लैश स्क्रीन नहीं बना लेते
class InitializationPlaceholder extends StatelessWidget {
  const InitializationPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Water Delivery System\nArchitecture Setup Complete.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
