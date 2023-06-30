class Avaliacao{


  String _idUsuario = "";
  String _titulo = "";
  String _descricao = "";
  String _data = "";

  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"



  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idUsuario" : this._idUsuario,
      "titulo"  : this.titulo,
      "descricao" : this.descricao,
      "data" : this.data,

    };

    return map;

  }



  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }
}