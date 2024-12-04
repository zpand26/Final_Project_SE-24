import 'package:northstars_final/models/se_compare_model.dart';


class SEComparePresenter {
  final SECompareModel seCompareModel;
  Function(String) updateView;


  SEComparePresenter(this.seCompareModel, this.updateView);



}