class AppTranslations {
  static String get(String key, bool isBengali) {
    return isBengali ? _bengali[key] ?? key : _english[key] ?? key;
  }

  static final Map<String, String> _bengali = {
    // Common
    'save': 'সংরক্ষণ',
    'saved': 'সংরক্ষিত',
    'next': 'পরবর্তী',
    'back': 'ফিরুন',
    'cancel': 'বাতিল',
    'delete': 'মুছুন',
    'close': 'বন্ধ করুন',
    'edit': 'সম্পাদনা',
    'update': 'আপডেট',
    
    // Profile Screen
    'animal_details': 'পশুর বিবরণ',
    'animal_name': 'পশুর নাম',
    'animal_name_hint': 'যেমন: গাভী-১',
    'body_weight': 'শরীরের ওজন (কেজি)',
    'milk_production': 'দুধ উৎপাদন (লিটার/দিন)',
    'milk_fat': 'দুধের চর্বি (%)',
    'milk_protein': 'দুধের প্রোটিন (%)',
    'lactation_week': 'দুগ্ধ সপ্তাহ',
    'pregnancy_week': 'গর্ভাবস্থা সপ্তাহ',
    'age_months': 'বয়স (মাস)',
    'daily_gain': 'দৈনিক বৃদ্ধি (গ্রাম/দিন)',
    
    // Ingredients Screen
    'select_ingredients': 'উপাদান নির্বাচন করুন',
    'forage': 'ঘাস',
    'concentrate': 'দানাদার খাদ্য',
    'additive': 'সংযোজন',
    'price_per_kg': 'মূল্য/কেজি',
    'inclusion': 'অন্তর্ভুক্তি',
    'daily_cost': 'দৈনিক খরচ',
    'energy_me': 'শক্তি (ME)',
    'protein_cp': 'প্রোটিন (CP)',
    'met': 'পূরণ',
    'deficit': 'ঘাটতি',
    
    // Results Screen
    'ration_results': 'রেশন ফলাফল',
    'cost_summary': 'খরচ সারাংশ',
    'total_cost_per_day': 'মোট খরচ/দিন',
    'cost_per_kg_milk': 'খরচ/কেজি দুধ',
    'nutrient_balance': 'পুষ্টি ভারসাম্য',
    'energy_breakdown': 'শক্তি বিভাজন',
    'maintenance': 'রক্ষণাবেক্ষণ',
    'lactation': 'দুগ্ধ উৎপাদন',
    'growth': 'বৃদ্ধি',
    'pregnancy': 'গর্ভাবস্থা',
    'semen': 'বীর্য',
    'daily_mixing_recipe': 'দৈনিক মিশ্রণ রেসিপি',
    'total_feed_to_mix': 'মোট খাদ্য মিশ্রণ',
    'required': 'প্রয়োজন',
    'supplied': 'সরবরাহ',
    
    // Saved Details
    'saved_report': 'সংরক্ষিত প্রতিবেদন',
    'delete_record': 'রেকর্ড মুছবেন?',
    'delete_confirm': 'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না।',
    'no_recipe_details': 'এই রেকর্ডের জন্য কোনো রেসিপি বিবরণ নেই।',
  };

  static final Map<String, String> _english = {
    // Common
    'save': 'Save',
    'saved': 'Saved',
    'next': 'Next',
    'back': 'Back',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'close': 'Close',
    'edit': 'Edit',
    'update': 'Update',
    
    // Profile Screen
    'animal_details': 'Animal Details',
    'animal_name': 'Animal Name',
    'animal_name_hint': 'e.g., Cow-1',
    'body_weight': 'Body Weight (kg)',
    'milk_production': 'Milk Production (L/day)',
    'milk_fat': 'Milk Fat (%)',
    'milk_protein': 'Milk Protein (%)',
    'lactation_week': 'Lactation Week',
    'pregnancy_week': 'Pregnancy Week',
    'age_months': 'Age (months)',
    'daily_gain': 'Daily Gain (g/day)',
    
    // Ingredients Screen
    'select_ingredients': 'Select Ingredients',
    'forage': 'Forage',
    'concentrate': 'Concentrate',
    'additive': 'Additive',
    'price_per_kg': 'Price/kg',
    'inclusion': 'Inclusion',
    'daily_cost': 'Daily Cost',
    'energy_me': 'Energy (ME)',
    'protein_cp': 'Protein (CP)',
    'met': 'Met',
    'deficit': 'Deficit',
    
    // Results Screen
    'ration_results': 'Ration Results',
    'cost_summary': 'Cost Summary',
    'total_cost_per_day': 'Total Cost/Day',
    'cost_per_kg_milk': 'Cost/kg Milk',
    'nutrient_balance': 'Nutrient Balance',
    'energy_breakdown': 'Energy Breakdown',
    'maintenance': 'Maintenance',
    'lactation': 'Lactation',
    'growth': 'Growth',
    'pregnancy': 'Pregnancy',
    'semen': 'Semen',
    'daily_mixing_recipe': 'Daily Mixing Recipe',
    'total_feed_to_mix': 'Total feed to mix',
    'required': 'Required',
    'supplied': 'Supplied',
    
    // Saved Details
    'saved_report': 'Saved Report',
    'delete_record': 'Delete Record?',
    'delete_confirm': 'This action cannot be undone.',
    'no_recipe_details': 'No recipe details available for this record.',
  };
}
