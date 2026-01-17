import 'package:home_widget/home_widget.dart';
import '../models/quote.dart';

class WidgetService {
  static const String _appGroupId =
      'group.com.example.quote_app'; // Relevant for iOS
  static const String _androidWidgetName = 'QuoteWidgetProvider';

  Future<void> updateWidget(Quote quote) async {
    try {
      await HomeWidget.saveWidgetData<String>('quote_id', quote.id ?? '');
      await HomeWidget.saveWidgetData<String>('quote_text', quote.text);
      await HomeWidget.saveWidgetData<String>(
        'quote_author',
        quote.author ?? '',
      );
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }
}
