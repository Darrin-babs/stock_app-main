import 'package:get/get.dart';

class DataBinding<T> {
  final Rxn<T> _rxn;

  DataBinding([T? initial]) : _rxn = Rxn<T>(initial);

  T? get value => _rxn.value;
  set value(T? v) => _rxn.value = v;
  Rxn<T> get rx => _rxn;
  void bindStream(Stream<T> stream) => _rxn.bindStream(stream);
}
