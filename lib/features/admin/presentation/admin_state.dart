abstract class AdminState {}

// 1. शुरुआती स्थिति
class AdminInitial extends AdminState {}

// 2. लोडिंग स्थिति (जब बैकएंड में डेटा सेव/अपडेट/डिलीट हो रहा हो)
class AdminLoading extends AdminState {}

// 3. काम सफलतापूर्वक पूरा होने की स्थिति
class AdminActionSuccessState extends AdminState {
  final String message;
  AdminActionSuccessState({required this.message});
}

// 4. एरर स्थिति
class AdminErrorState extends AdminState {
  final String errorMessage;
  AdminErrorState({required this.errorMessage});
}
