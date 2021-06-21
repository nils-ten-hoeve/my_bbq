
import 'package:flutter/widgets.dart';
import 'package:my_bbq/page/recipe.dart';
import 'package:provider/provider.dart';

class Navigation extends ChangeNotifier {
  Widget _currentPage;

  static final Navigation _singleton = Navigation._();

  factory Navigation() {
    return _singleton;
  }

  Navigation._(): _currentPage=RecipeListPage(); //ConnectPage();

  Widget get currentPage=> _currentPage;

  set currentPage(Widget newCurrentPage) {
    _currentPage=newCurrentPage;
    notifyListeners();
  }
}

openNewPage(BuildContext context, Widget newPage) {
  Provider.of<Navigation>(context, listen: false).currentPage = newPage;
}