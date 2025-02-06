import 'package:get_it/get_it.dart';
import 'navigation_service.dart';



GetIt locator=GetIt.instance;
bool isRegistered =false;
Future initLocatorService()async{
  if(!isRegistered){
    locator.registerFactory(() => NavigationService());
    isRegistered=true;
  }
}