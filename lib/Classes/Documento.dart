class Pasta{


  String _titulo = "";
  String _data = "";


  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"



  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {

      "titulo"  : this.titulo,
      "data" : this.data,

    };

    return map;

  }


  String get data => _data;

  set data(String value) {
    _data = value;
  }



  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }


}
class Documento{


  String _url = "";
  String _titulo = "";
  String _nome = "";
  String _data = "";
  String _dreitorio = "";

  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"



  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {

      "titulo"  : this.titulo,
      "url" : this.url,
      "nome":this.nome,
      "data" : this.data,
      "diretorio": this.dreitorio

    };

    return map;

  }


  String get dreitorio => _dreitorio;

  set dreitorio(String value) {
    _dreitorio = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }



  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}