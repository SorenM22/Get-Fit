import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/presenter/presenter.dart';
//User sees
class View {
  void _pressedAccountButton() {
    Presenter presenter = Presenter();
    presenter.buttonPushed();
  }
}