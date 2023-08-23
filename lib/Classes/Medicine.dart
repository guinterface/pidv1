import 'package:get/get.dart';

class Medicine{


  String _idUsuario = "";
  String _titulo = "";
  List<String> _diasdaSemana = [];
  List<String> _horario = [];
  String _categoria = "";
  String _descricao = "";
  String _identidade = "";

  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"



  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idUsuario" : this._idUsuario,
      "titulo"  : this.titulo,
      "diasdaSemana": this.diasdaSemana,
      "horario": this.horario,
      "categoria": this.categoria,
      "descricao": this.descricao,
      "identidade":this.identidade


    };

    return map;

  }


  List<String> get diasdaSemana => _diasdaSemana;

  set diasdaSemana(List<String> value) {
    _diasdaSemana = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  List<String> get horario => _horario;

  set horario(List<String> value) {
    _horario = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get identidade => _identidade;

  set identidade(String value) {
    _identidade = value;
  }

}
class Comida{



  String _titulo = "";
  int _calorias = 0;
  String _quantidade = "";
  String _foto = "";




  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "calorias" : this.calorias,
      "titulo"  : this.titulo,
      "quantidade": this.quantidade,
      "foto": this.foto,


    };

    return map;

  }

  String get foto => _foto;

  set foto(String value) {
    _foto = value;
  }

  String get quantidade => _quantidade;

  set quantidade(String value) {
    _quantidade = value;
  }

  int get calorias => _calorias;

  set calorias(int value) {
    _calorias = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }
}

class FoodController extends GetxController{

  var _foods = {}.obs;
  void addFood(String food){
    if(_foods.containsKey(food)){
      _foods[food]+=1;
    }else{
      _foods[food] = 0;
    }
  }
  void dimFoods(String food){
    if(_foods[food]!=0){
      _foods[food]-=1;
    }else{
      _foods[food] = 0;
    }
  }

  get foods => _foods;

  set foods(value) {
    _foods = value;
  }

}
