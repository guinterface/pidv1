class Usuario {

  String _idUsuario = "";
  String _nome ="";
  String _email = "";
  String _urlImagem ="";
  String _descricao ="";
  String _senha ="";
  String _tipoUsuario ="";
  String _nascimento = "";
  String _doencas = "";
  int _peso = 0;
  int _altura = 0;
  String _especializacao = "";
  int _calorias = 0;
  String _data = "";
  List<String>_listaDatas = [""];
  List<int>_listaCalorias = [0];



  Usuario();

  Map<String, dynamic> toMap() {


    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "tipoUsuario": this.tipoUsuario,
      "foto": this.urlImagem,
      "descricao": this.descricao,
      "idUsuario": this.idUsuario,
      "nascimento": this.nascimento,
      "peso": this.peso,
      "altura": this.altura,
      "doencas": this.doencas,
      "especializacao": this.especializacao,
      "calorias": this.calorias,
      "data": this.data,
      "listaCalorias": this.listaCalorias,
      "listaData": this.listaDatas,




    };
    return map;

  }


  List<String> get listaDatas => _listaDatas;

  set listaDatas(List<String> value) {
    _listaDatas = value;
  }

  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get especializacao => _especializacao;

  set especializacao(String value) {
    _especializacao = value;
  }

  int get altura => _altura;

  set altura(int value) {
    _altura = value;
  }

  int get peso => _peso;

  set peso(int value) {
    _peso = value;
  }

  String get doencas => _doencas;

  set doencas(String value) {
    _doencas = value;
  }

  String get nascimento => _nascimento;

  set nascimento(String value) {
    _nascimento = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  int get calorias => _calorias;

  set calorias(int value) {
    _calorias = value;
  }

  List<int> get listaCalorias => _listaCalorias;

  set listaCalorias(List<int> value) {
    _listaCalorias = value;
  }
}