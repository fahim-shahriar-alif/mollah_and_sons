import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isBengali => locale.languageCode == 'bn';

  // Common
  String get appName => locale.languageCode == 'bn' ? 'মোল্লা এন্ড সন্স' : 'Mollah And Sons';
  String get loading => locale.languageCode == 'bn' ? 'লোড হচ্ছে...' : 'Loading...';
  String get error => locale.languageCode == 'bn' ? 'ত্রুটি' : 'Error';
  String get success => locale.languageCode == 'bn' ? 'সফল' : 'Success';
  String get cancel => locale.languageCode == 'bn' ? 'বাতিল' : 'Cancel';
  String get confirm => locale.languageCode == 'bn' ? 'নিশ্চিত' : 'Confirm';
  String get close => locale.languageCode == 'bn' ? 'বন্ধ' : 'Close';
  String get save => locale.languageCode == 'bn' ? 'সংরক্ষণ' : 'Save';

  // Authentication
  String get login => locale.languageCode == 'bn' ? 'লগইন' : 'Login';
  String get signup => locale.languageCode == 'bn' ? 'সাইন আপ' : 'Sign Up';
  String get email => locale.languageCode == 'bn' ? 'ইমেইল' : 'Email';
  String get emailAddress => locale.languageCode == 'bn' ? 'ইমেইল ঠিকানা' : 'Email Address';
  String get password => locale.languageCode == 'bn' ? 'পাসওয়ার্ড' : 'Password';
  String get forgotPassword => locale.languageCode == 'bn' ? 'পাসওয়ার্ড ভুলে গেছেন?' : 'Forgot Password?';
  String get rememberMe => locale.languageCode == 'bn' ? 'আমাকে মনে রাখুন' : 'Remember Me';
  String get signInWithGoogle => locale.languageCode == 'bn' ? 'গুগল দিয়ে সাইন ইন' : 'Sign in with Google';
  String get dontHaveAccount => locale.languageCode == 'bn' ? 'অ্যাকাউন্ট নেই?' : 'Don\'t have an account?';
  String get alreadyHaveAccount => locale.languageCode == 'bn' ? 'ইতিমধ্যে অ্যাকাউন্ট আছে?' : 'Already have an account?';
  
  // App tagline and validation messages
  String get appTagline => locale.languageCode == 'bn' ? 'আপনার কৃষি সমাধানের অংশীদার' : 'Your Agricultural Solutions Partner';
  String get emailRequired => locale.languageCode == 'bn' ? 'ইমেইল প্রয়োজন' : 'Email is required';
  String get enterValidEmail => locale.languageCode == 'bn' ? 'বৈধ ইমেইল প্রবেশ করুন' : 'Enter a valid email';
  String get passwordRequired => locale.languageCode == 'bn' ? 'পাসওয়ার্ড প্রয়োজন' : 'Password is required';
  String get passwordMinLength => locale.languageCode == 'bn' ? 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে' : 'Password must be at least 6 characters';
  String get signUpText => locale.languageCode == 'bn' ? 'নিবন্ধন করুন' : 'Sign Up';
  String get loginFailed => locale.languageCode == 'bn' ? 'লগইন ব্যর্থ হয়েছে' : 'Login failed';
  String get invalidCredentials => locale.languageCode == 'bn' ? 'ভুল ইমেইল বা পাসওয়ার্ড' : 'Invalid username and password';

  // Dashboard
  String get dashboard => locale.languageCode == 'bn' ? 'ড্যাশবোর্ড' : 'Dashboard';
  String get welcomeBack => locale.languageCode == 'bn' ? 'স্বাগতম' : 'Welcome Back';
  String get searchProducts => locale.languageCode == 'bn' ? 'পণ্য খুঁজুন' : 'Search Products';
  String get categories => locale.languageCode == 'bn' ? 'ক্যাটেগরি' : 'Categories';
  String get allProducts => locale.languageCode == 'bn' ? 'সব পণ্য' : 'All Products';
  String get chemicalFertilizer => locale.languageCode == 'bn' ? 'রাসায়নিক সার' : 'Chemical Fertilizer';
  String get organicFertilizer => locale.languageCode == 'bn' ? 'জৈব সার' : 'Organic Fertilizer';
  String get micronutrient => locale.languageCode == 'bn' ? 'মাইক্রোনিউট্রিয়েন্ট' : 'Micronutrient';

  // Products
  String get products => locale.languageCode == 'bn' ? 'পণ্য' : 'Products';
  String get addToCart => locale.languageCode == 'bn' ? 'কার্টে যোগ করুন' : 'Add to Cart';
  String get price => locale.languageCode == 'bn' ? 'দাম' : 'Price';
  String get inStock => locale.languageCode == 'bn' ? 'স্টকে আছে' : 'In Stock';
  String get outOfStock => locale.languageCode == 'bn' ? 'স্টকে নেই' : 'Out of Stock';
  String get productDetails => locale.languageCode == 'bn' ? 'পণ্যের বিবরণ' : 'Product Details';

  // Cart
  String get cart => locale.languageCode == 'bn' ? 'কার্ট' : 'Cart';
  String get shoppingCart => locale.languageCode == 'bn' ? 'শপিং কার্ট' : 'Shopping Cart';
  String get viewCart => locale.languageCode == 'bn' ? 'কার্ট দেখুন' : 'View Cart';
  String get clearAll => locale.languageCode == 'bn' ? 'সব মুছুন' : 'Clear All';
  String get totalItems => locale.languageCode == 'bn' ? 'মোট আইটেম:' : 'Total Items:';
  String get totalAmount => locale.languageCode == 'bn' ? 'মোট পরিমাণ:' : 'Total Amount:';
  String get proceedToCheckout => locale.languageCode == 'bn' ? 'চেকআউট করুন' : 'Proceed to Checkout';
  String get cartEmpty => locale.languageCode == 'bn' ? 'আপনার কার্ট খালি' : 'Your cart is empty';
  String get addSomeFertilizers => locale.languageCode == 'bn' ? 'কিছু সার যোগ করুন' : 'Add some fertilizers to get started';
  String get clearCart => locale.languageCode == 'bn' ? 'কার্ট খালি করুন' : 'Clear Cart';
  String get clearCartConfirm => locale.languageCode == 'bn' ? 'আপনি কি নিশ্চিত যে আপনি কার্ট থেকে সব আইটেম সরাতে চান?' : 'Are you sure you want to remove all items from your cart?';
  String get cartCleared => locale.languageCode == 'bn' ? 'কার্ট সফলভাবে খালি করা হয়েছে' : 'Cart cleared successfully';

  // Checkout & Orders
  String get checkout => locale.languageCode == 'bn' ? 'চেকআউট' : 'Checkout';
  String get placeOrder => locale.languageCode == 'bn' ? 'অর্ডার দিন' : 'Place Order';
  String get orderPlaced => locale.languageCode == 'bn' ? 'অর্ডার সফলভাবে দেওয়া হয়েছে!' : 'Order placed successfully!';
  String get orderFailed => locale.languageCode == 'bn' ? 'অর্ডার দিতে ব্যর্থ। আবার চেষ্টা করুন।' : 'Failed to place order. Please try again.';
  String get orderDeliveryInfo => locale.languageCode == 'bn' ? 'আপনার অর্ডার প্রক্রিয়া করা হবে এবং ২-৩ কার্যদিবসের মধ্যে ডেলিভারি হবে।' : 'Your order will be processed and delivered within 2-3 business days.';

  // Order History
  String get orderHistory => locale.languageCode == 'bn' ? 'অর্ডার ইতিহাস' : 'Order History';
  String get noOrderHistory => locale.languageCode == 'bn' ? 'কোন অর্ডার ইতিহাস নেই' : 'No order history';
  String get pastOrdersAppear => locale.languageCode == 'bn' ? 'আপনার পূর্ববর্তী অর্ডারগুলি এখানে দেখা যাবে' : 'Your past orders will appear here';
  String get viewDetails => locale.languageCode == 'bn' ? 'বিস্তারিত দেখুন' : 'View Details';
  String get reorder => locale.languageCode == 'bn' ? 'পুনরায় অর্ডার' : 'Reorder';
  String get orderStatus => locale.languageCode == 'bn' ? 'অর্ডার স্ট্যাটাস' : 'Order Status';
  String get pending => locale.languageCode == 'bn' ? 'অপেক্ষমাণ' : 'Pending';
  String get processing => locale.languageCode == 'bn' ? 'প্রক্রিয়াকরণ' : 'Processing';
  String get delivered => locale.languageCode == 'bn' ? 'ডেলিভার হয়েছে' : 'Delivered';
  String get inTransit => locale.languageCode == 'bn' ? 'পথে আছে' : 'In Transit';

  // Profile
  String get profile => locale.languageCode == 'bn' ? 'প্রোফাইল' : 'Profile';
  String get changePassword => locale.languageCode == 'bn' ? 'পাসওয়ার্ড পরিবর্তন' : 'Change Password';
  String get logout => locale.languageCode == 'bn' ? 'লগআউট' : 'Logout';
  String get language => locale.languageCode == 'bn' ? 'ভাষা' : 'Language';
  String get english => locale.languageCode == 'bn' ? 'ইংরেজি' : 'English';
  String get bengali => locale.languageCode == 'bn' ? 'বাংলা' : 'Bengali';

  // Navigation
  String get home => locale.languageCode == 'bn' ? 'হোম' : 'Home';
  String get history => locale.languageCode == 'bn' ? 'ইতিহাস' : 'History';

  // Admin
  String get addProduct => locale.languageCode == 'bn' ? 'পণ্য যোগ করুন' : 'Add Product';
  String get productName => locale.languageCode == 'bn' ? 'পণ্যের নাম' : 'Product Name';
  String get description => locale.languageCode == 'bn' ? 'বিবরণ' : 'Description';
  String get category => locale.languageCode == 'bn' ? 'ক্যাটেগরি' : 'Category';
  String get unit => locale.languageCode == 'bn' ? 'একক' : 'Unit';
  String get stockQuantity => locale.languageCode == 'bn' ? 'স্টক পরিমাণ' : 'Stock Quantity';

  // Currency
  String get currency => locale.languageCode == 'bn' ? '৳' : '৳';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'bn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
