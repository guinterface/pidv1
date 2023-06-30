import 'dart:async';
import 'dart:collection';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pidv1/Classes/Medicine.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class SubscriberChart extends StatelessWidget {
  final List<CaloricSeries> data;


  SubscriberChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CaloricSeries, String>> series = [
      charts.Series(
          id: "Calorias",
          data: data,
          domainFn: (CaloricSeries series, _) => series.day,
          measureFn: (CaloricSeries series, _) => series.calories,
          colorFn: (CaloricSeries series, _) => series.barColor
      )
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Calorias acumuladas por dia",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true,

                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        lineHeight: 3,
                        fontSize: 5,
                        fontWeight: "Bold"


                      ),

                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class CaloricSeries {
  final String day;
  final int calories;
  final charts.Color barColor;

  CaloricSeries(
      {
        required this.day,
        required this.calories,
        required this.barColor
      }
      );
}

class ChercherFoods extends StatefulWidget {
  const ChercherFoods({Key? key}) : super(key: key);

  @override
  _ChercherFoodsState createState() => _ChercherFoodsState();
}

class _ChercherFoodsState extends State<ChercherFoods> {
  final _foodController = Get.put(FoodController());
  final _controler  = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerDes = TextEditingController();
  TextEditingController _pesquisa = TextEditingController();
  String _textoPesquisa = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  int _calorias = 0;
  int _meta = 0;
  String _dataUsuario = "";
  List<CaloricSeries> listaGrafico = [];
  List<String>_alimentacios = [
    "Bife bovino",
    "Almôndega (bovina)",
    "Almôndega (frango) ",
    "Almôndega (peru)",
    "Bife (carne magra)",
    "Bisteca bovina",
    "Bisteca de carneiro",
    "Bisteca suína",
    "Cabrito",
    "Carne bovina gorda",
    "Carne bovina magra",
    "Carne de carneiro assada",
    "Carne de panela",
    "Carne de porco salgada",
    "Carne de soja cozida",
    "Carne de vitela (cozida)"
    ,"Carne moída"
    ,"Carne-seca"
    ,"Carne de soja"
    ,"Carne de vaca"
    ,"Carpaccio com molho"
    ,"Charque"
    ,"Chester"
    ,"Chuleta (suína)"
    ,"Coelho"
    ,"Contra filé bovino"
    ,"Peixes"
    ,"Arenque defumado"
    ,"Atum em Aleo"
    ,"Atum na salmoura"
    ,"Bacalhau"
    ,"Bacalhau / Atum fresco"
    ,"Badejo"
    ,"Camarao"
    ,"Camarao com catupiry"
    ,"Camarao seco"
    ,"Caçao"
    ,"Carne de siri"
    ,"Dourado"
    ,"Haddock"
    ,"Kani kama"
    ,"Lagosta"
    ,"Linguado"
    ,"Lula"
    ,"Marisco"
    ,"Merluza"
    ,"Mexilhao"
    ,"Namorado"
    ,"Ostras"
    ,"Pargo"
    ,"Pescada branca"
    ,"Pintado"
    ,"Polvo"
    ,"Salmao"
    ,"Salmao Defumado"
    ,"Sardinha fresca"
    ,"Sardinha em óleo"
    ,"Sardinha com tomate"
    ,"Sashimi"
    ,"Truta"
    ,"Vieiras"
    ,"AII-Bran"
    ,"Araruta"
    ,"AITOZ"
    ,"Arroz à grega"
    ,"Arroz integral"
    ,"Aveia"
    ,"Corn flakes"
    ,"Ervilha"
    , "Farelo de aveia"
    , "Farinha de mandioca"
    , "Farinha de trigo"
    , "Farinha de milho"
    , "Farinha de rosca"
    , "Fava"
    , "Feijao"
    , "Fubá"
    , "Gergelim"
    , "Germe de trigo"
    , "Granola"
    , "Grao de bico"
    , "Hosomaki"
    , "Lentilha"
    , "Levedo de cerveja"
    , "Maisena"
    , "Mandioca"
    , "Mandioquinha"
    , "MIlho"
    , "Musli"
    , "Neston"
    , "Pipoca"
    , "Polvilho doce"
    , "Risoto"
    , "Salada de maionese"
    , "Sequilho"
    , "Soja"
    , "Souflês"
    , "Sucrilhos"
    , "Sushi"
    , "Tabule (sem azeite)"
    , "Torrada"
    , "Trigo para quibe (cozido)"
    , "Trigo para quibe (grao)"
    , "Baked potato (sem recheio)"
    , "Batata"
    , "Barra de cereais"
    , "Batata doce"
    , "Batata-inglesa cozida"
    , "Canelone"
    , "Capelete"
    , "Creme de milho"
    , "Cuscuz marroquino"
    , "Farofa"
    , "Lasanha"
    , "Macarrao cozido"
    , "Macarrao instantâneo"
    , "Milho cozido"
    , "Mingau de milho"
        "Nhoque"
    , "Panqueca com molho"
    , "Crepe sem molho"
    , "Polenta assada"
    , "Purê de batata"
    ,"Quiche"
    , "Ravioli"
    , "Rondelli"
    , "Temaki sem maionese"
    , "Torta salgada"
    ,"Yakissoba"
    ,"Abacaxi"
    , "Abacate"
    , "Abricó"
    , "Ameixa amarela"
    , "Ameixa preta fresca"
    , "Ameixa vermelha"
    , "Acerola"
    , "Amora"
    , "Banana da terra"
    , "Banana maça"
    , "Banana nanica"
    , "Banana OUO"
    , "Banana prata"
    , "Banana seca"
    , "Blueberry"
    , "Caju"
    , "Caqui"
    , "Carambola"
    , "Cereja"
    , "Damasco fresco"
    , "Espiga de milho"
    , "FIGO"
    , "Framboesa"
    , "Fruta pao"
    , "Fruta do conde"
    , "Goiaba"
    , "Grapefruit"
    , "Graviola"
    , "Jabuticaba"
    , "Jaca"
    , "Kiwi"
    , "Laranja"
    , "Lichia"
    , "Lima da pérsia"
    , "Maça"
    , "Mamao"
    , "Manga"
    , "Maracujá"
    , "Melancia"
    , "Melao"
    , "Morango"
    , "Nectarina"
    , "Nêspera"
    ,"Pêssego"
    ,"Papaya"
    ,"Pêra"
    ,"Pitanga"
    ,"Salada de frutas"
    ,"Tâmara"
    ,"Tangerina (mexerica)"
    ,"Tomate (extrato)"
    ,"Tomate (polpa)"
    ,"Tomate (purê)"
    ,"Uvas"
    ,"LEITES E IOGURTES"

    ,        "Coalhada seca"
    ,        "Creme de leite"
    ,        "Danone"
    ,        "Danoninho"
    , "logurte batido"
    ,  "logurte desnatado"
    , "logurte com mel"
    , "logurte natural"
    , "Leite desnatado"
    , "Leite semidesnatado"
    , "Leite em pó"
    , "Leite de soja"
    , "Leite integral"
    , "Mix Vigor"
    , "Toddynho"
    , "Yakult"
    , "PAES, BOLACHAS E BOLOS"
    , "Biscoito água e sal"
    , "Biscoito de aveia / mel"
    , "Biscoito de chocolate"
    , "Biscoito de COCO"
    , "Biscoito de leite"
    , "Biscoito inglês"
    , "Biscoito Maria"
    , "Biscoito recheado de chocolate"
    , "Biscoito recheado de doce de leite"
    , "Biscoito recheado de goiaba"
    , "Biscoito recheado de morango"
    , "Biscoito wafer de baunilha"
    , "Biscoito wafer de chocolate"
    , "Biscoito wafer de morango"
    , "Biscoito wafer de Nozes"
    , "Biscoito wafer sabor doce de leite"
    , "Bisnaguinha"
    , "Bolacha cream-craker"
    , "Bolacha doce"
    , "Bolacha recheada"
    , "Bolo comum (pao de I6)"
    , "Bolo de abacaxi"
    , "Bolo de ameixa caseiro"
    , "Bolo de banana caseiro"
    , "Bolo de baunilha"
    , "Bolo de café / chocolate caseiro"
    , "Bolo de cenoura caseiro"
    , "Bolo de chocolate"
    , "Bolo de COCO"
    , "Bolo de fubá caseiro"
    , "Bolo de laranija"
    , "Bolo de limao caseiro"
    , "Bolo de maça"
    , "Bolo de mandioca"
    , "Bolo de maracujá caseiro"
    , "Bolo de mel"
    , "Bolo de milho caseiro"
    , "Bolo formigueiro"
    , "Bolo inglês"
    , "Briochi"
    , "Broa de milho"
    , "Cookies"
    , "Croissant"
    , "Panetone"
    , "Pao caseiro"
    , "Pao de batata"
    , "Pao de centeio"
    , "Pao doce"
    , "Pao de fôrma"
    , "Pao francês"
    , "Pao de fibras"
    , "Pao de glúten"
    , "Pao de hambúrguer"
    , "Pao de hot dog"
    , "Pao integral"
    , "Pao italiano"
    , "Pao de leite"
    , "Pao de IO"
    , "Pao de milho"
    , "Pao preto"
    , "Pao de queijo"
    , "Pao sírio"
    , "Pao sovado"
    , "Pao sueco"
    , "Rocambole de chocolate"
    , "Rocambole de doce de leite"
    , "Torrada Bi-Tost"
    , "Alouette"
    , "Blanquet (peru)"
    , "Camembert / Brie"
    ,"Catupiry"
    ,  "Cheddar"
    ,  "Chester Lunch"
    ,  "Cottage"
    ,  "Cream cheese"
    ,  "Edam"
    ,  "Fondue de queijo"
    ,  "Gorgonzola"
    ,  "Gouda"
    ,  "Gruyére"
    ,  "Lombo defumado"
    ,  "Mortadela (frango)"
    ,  "Mortadela (suína)"
    ,  "Mussarela"
    ,  "Mussarela de búfala"
    , "Parmesao"
    ,"Pastrame"
    ,"Peito de frango defumado"
    ,"Peito de peru defumado"
    ,"Polenguinho"
    , "Presunto CU"
    , "Presunto (peru)"
    , "Presunto (SUINO)"
    ,"Provolone"
    ,"Queijo branco"
    ,"Queijo de minas"
    ,"Queijo prato"
    ,"Queijo de soja (tofu)"
    ,"Queijo SUIÇO"
    ,"Requeijao"
    ,"Ricota"
    ,"Roquefort"
    ,"Rosbife"
    ,"Salame"
    ,"Salsichao"
    ,"Agua de Coco"
    ,"Agua tônica"
    ,"Batidas"
    ,"Bebida energética"
    ,"Blood Mary"
    ,"Caipirinha"
    ,"Cappuccino"
    ,"Cappuccino (em pó)"
    ,"Caldo de cana"
    ,"Cerveja"
    ,"Cerveja bock"
    ,"Cerveja preta"
    ,"Champanhe"
    ,"Chá industrializado"
    ,"Chopp"
    ,"Conhaque"
    ,"Coquetel de frutas"
    ,"Gatorade"
    ,"Gin / Cachaça"
    ,"Groselha"
    ,"Licor"
    ,"Martini"
    ,"Quentao"
    ,"Refrigerante"
    ,"Refresco de frutas"
    ,"Rum"
    ,"Suco natural"
    ,"Uísque / Saquê"
    ,"Vermute"
    ,"Vinho branco doce"
    ,"Vinho branco seco"
    ,"Vinho do porto"
    ,"Vinho tinto"
    ,"Vodca"
    ,"Açúcar"
    ,"Açúcar cristal"
    ,"Açúcar de confeiteiro"
    ,"Açúcar mascavo"
    ,"Bala"
    ,"Cereja em calda"
        ",Chiclete"
    , ",Creme de abacate"
    , ",Doce de fruta em pasta"
    , ",Fibrax"
    , ",Frutas em calda"
    , ",Gelatina"
    , ",Geléia"
    , ",Goiabada"
    , ",Marrom glacê"
    ,"Mel"
    ,  ",Sagu"
    ,  ",Sorvetes de frutas sem leite"
    ,  ",Suspiro"
    ,  "DOCES Il"
    ,  "Arroz doce"
    ,  "Bijou"
    ,  "Bolo comum"
    ,  "Bomba creme"
    ,  "Bomba de chocolate"
    ,  "Bombom (Sonho de Valsa)"
    , "Brigadeiro"
    ,   "Cajuzinho"
    ,   "Camafeu / Doces caramelados"
    ,   "Canjica"
    ,   "Chantilly"
    ,   "Chocolate"
    ,   "Chocolate ao leite"
    ,   "Chocolate Bis"
    ,   "Chocolate branco"
    ,   "Churro com doce de leite"
    ,   "Churro sem doce de leite"
    ,  "Coberturas"
    ,  "Cocada"
    ,  "Creme de papaya"
    ,  "Doce de leite"
    ,  "Doces sírios"
    ,  "Fios de OVOS"
    ,  "Folheado com creme"
    ,  "Frozen yogurt"
    ,  "Fruta cristalizada"
    ,  "Gemada"
    ,  "Goiabada"
    ,  "Kaak (doce sírio)"
    ,  "Leite condensado"
    ,  "Manjar"
    ,  "Maria mole"
    ,  "Marmelada"
    ,  "Marrom glacê"
    ,  "Mel de abelhas"
    ,  "Merengue"
    ,  "M&M amendoim"
    ,  "M&M chocolate"
    ,  "MOUSSE"
    ,  "Pao de mel"
    ,  "Paçoca"
    ,  "Pamonha"
    ,  "Papo de anjo"
    ,  "Pavê"
    ,  "Pé de moleque"
    ,  "Pipoca doce"
    ,  "Pudim"
    ,  "Queijadinha"
    ,  "Quindim"
    ,  "Rapadura"
    ,  "Sonho"
    ,  "Sorvete com leite"
    ,  "Tapioca"
    ,  "Tortas doces"
    ,  "Trufa tradicional"
    ,  "Caldo de carne"
    ,  "Caldo de galinha"
    ,  "Caldo verde"
    ,  "Canja"
    ,  "Catchup"
    ,  "Creme de cebola"
    ,  "Creme de cogumelos"
    ,  "Creme de ervilha"
    ,  "Creme de espinafre"
    ,  "Creme de legumes"
    ,  "Creme de milho"
    ,  "Maionese"
    ,  "Mango chutney"
    ,  "Missoshiro"
    ,  "Molho à bolonhesa"
    ,  "Molho branco"
    ,  "Molho de gergelim"
    ,  "Molho inglês"
    ,  "Molho de mostarda"
    , "Molho roquefort"
    ,   "Molho rosê"
    ,   "Molho tártaro"
    ,   "Molho de tomate"
    ,   "Molho de iogurte"
    ,   "Mostarda"
    ,   "Sopa creme de abobrinha"
    ,   "Sopa creme de couve-flor"
    ,   "Sopa de batata"
    ,   "Sopa de creme de abóbora"
    ,    "Sopa de feijao"
    ,    "Sopa de frango"
    ,    "Sopa de frutos do mar"
    ,    "Sopa de grao de bico"
    ,  "Sopa de grao de bico com lingúiça"
    ,  "Sopa de grao de bico com macarrao"
    ,  "Sopa de lentilha"
    ,  "Sopa de tomate"
    ,  "Sopa de vegetais le II"
    ,  "Ameixa seca"
    ,  "Amêndoa"
    ,  "Amendoim"
    ,  "Avela"
    ,  "Azeitona"
    ,  "Baconzitos"
    ,  "Banana seca"
    ,  "Barra de cereais"
    ,  "Batata Chips"
    ,  "Batata Pringle's"
    ,  "Biscoito de polvilho"
    ,  "Biscoitos Minibits"
    ,  "Bolinho de chuva"
    ,  "Castanha de caju"
    ,  "Castanha do pará"
    , "Castanha portuguesa / Pinhao"
    ,   "Caviar"
    ,   "Côco ralado"
    ,   "Damasco seco"
    , "Figo SECO"
    ,  "Maça seca"
    ,  "NOZ"
    ,  "Patê de bacon"
    ,  "Patê de berinjela"
    ,"Patê de carne"
    ,"Patê de figado"
    ,"Patê de galinha"
    ,"Patê de presunto"
    ,"Pêra seca"
    ,"Pipoca estourada"
    ,"Pistache"
    ,"Rabanada"
    ,"Rosquinha"
    , "Salgadinhos assados"
    , "Salgadinhos fritos"
    , "Tomate seco"
    , "Tremoço"
    ,"Uva passa"
    ,"Bacon Pieces Light"
    ,"Bala diet"
    ,"Bolacha doce diet"
    ,"Bolo diet"
    ,"Cerveja light"
    , "Chá diet"
    , "Chiclete diet"
    , "Chocolate em pó diet"
    , "Clight diet"
    , "Cream cheese light"
    , "Creme de leite diet"
    , "Doce de leite diet"
    , "Frozen diet"
    , "Gelatina diet"
    , "Geléia de mocotó diet"
    , "Geléia diet"
    , "Groselha diet"
    , "logurte diet ou light"
    , "Leite condensado diet"
    , "Maionese light"
    , "Margarina light"
    , "Marshmellow diet"
    , "Pao diet ou light"
    , "Pipoca light"
    , "Pudim diet"
    , "Queijo Danubio light"
    , "Refrigerante diet / light"
    , "Requeijao light"
    , "Shakes diet com água"
    , "Shakes diet com leite desnatado"
    , "Sorvete diet ou light"
    , "Suco diet ou light"
    ,"Arenque marinado"
    ,  "Biscoitos de cebola (Kichalech mit tzibale)"
    , "Bolinhos de peixe (Guefilte Fish)"
    ,  "Bolo de mel (Onek Leikach)"
    ,  "Caldo de frango (Guildene)"
    ,  "Chalah"
    ,  "Compota de Pessach"
    , "Condimento para peixe (Chrein)"
    , "Falafel"
    , "Falso macarrao (Spaetzle)"
    , "Homus"
    , "Maça assada com nozes"
    , "Massa frita para sopa (Mondeleck)"
    , "Matze"
    , "Panquecas (Blintses)"
    , "Pastéis cozidos (Varenikes)"
    , "Pastéis de batata (Knishes)"
    , "Pastéis de ricota (Bureka)"
    , "Pepino agridoce"
    , "Pepino em conserva"
    , "Repolho roxo com maça"
    , "Salada de fígado de galinha"
    , "Salada de ovos (Eir mit tzibale)"
    , "Salada de tahine"
    , "Sopa de beterraba (Borsht)"
    , "Tchoulent simples (cozido)"
    , "Torta de queijo (Kese Kejel)"
    , "Trigo sarraceno (Kashe)"
    , "Americano"
    , "Bauru"
    , "Beirute"
    , "Cachorro quente"
    , "Cheese salada"
    , "Cheese burger"
    , "Misto quente"
    , "Pastel de came"
    , "Pastel de palmito"
    , "Pastel de queijo"
    , "Queijo quente"
    , "Sanduíche de frango com maionese"
    , "Sanduíche natural atum com maionese"
    , "Calabreza"
    , "Escarola"
    , "Frango com catupiry"
    , "Marguerita"
    , "Mussarela"
    , "Portuguesa"
    , "Quatro queijos"
    , "Big Mac"
    , "Cheddar McMelt"
    , "Cheesebúrguer"
    , "Chicken McNuggets com 6 unidades"
    , "Hambúrguer"
    , "McChicken"
    , "McCookies"
    , "McFiISh"
    , "McrFritas pequena"
    , "McFritas média"
    , "McrFritas grande"
    , "McFruit pequeno"
    , "McFruit médio"
    , "McSalad Bacon"
    , "Milk shake pequeno"
    , "Milk shake médio"
    , "Molho (McNuggets)"
    , "Quarteirao com queijo"
    , "Sorvete de casquinha McDonald's"
    , "Sundae McDonald's"
    , "Torta McDonald's"
    , "Alcatra"
    , "Contrafilé"
    , "Coraçao de galinha"
    , "Costela de boi"
    , "Costela de porco"
    , "Cupim"
    , "Filé mignon"
    , "Fraldinha"
    , "Frango com pele"
    , "Javali"
    , "Maminha"
    , "Linguiça"
    , "Perna de carneiro"
    , "Picanha"
    , "T-Bone"
    , "Acarajé"
    ,  "Angu"
    , "Arroz de carreteiro"
    ,  "Arroz com pequi"
    ,  "Baiao de dois"
    , "Bobó de camarao"
    , "Caldeirada de frutos do mar"
    , "Caruru"
    , "Casquinha de siri"
    , "CUSCUZ"
    , "Dobradinha ensopada"
    , "Farofa de pinhao"
    , "Feijao tropeiro"
    , "Feijoada"
    , "Fritada de caranguejo"
    , "Galinhada"
    , "Leitao pururuca"
    , "Moqueca de peixe"
    , "Paçoca de carne de sol"
    , "Pirao de peixe"
    , "Quibebe"
    , "Rabada"
    , "Roupa velha"
    , "Torresmo pururuca"
    , "Tutu de feijao"
    , "Vatapá"
    , "Abobrinha recheada"
    , "Charuto de uva"
    , "Charuto de repolho"
    , "Coalhada seca"
    ,"Coalhada fresca"
    , "Esfiha de queijo"
    , "Esfiha de carne"
    ,"Fogazza de calabreza"
    ,"Fogazza de catupiry"
    ,"Fogazza de mussarela"
    ,"Homus"
    ,"Kafta na bandeja"
    ,"Prato verao"
    , "Prato primavera"
    ,"Quibe frito"
    ,"Tabule"
    ,"Arroz chop-suei"
    ,"BifUM"
    ,"Camarao apimentado"
    ,"Camarao ao molho de gengibre"
    ,"Camarao chop-suei"
    ,"Carne ao molho curry"
    ,"Chop-suei de carne"
    ,"Família feliz"
    ,"Filé em tiras"

    ,"Filé em tiras especial"
    ,"Filé fatiado / Filé fatiado especial"
    ,"Frango agridoce"
    ,"Frango ao Curry"
    ,"Frango ao molho de gengibre"
    ,"Frango chop-suei"
    , "Frango frito"
    , "Frango xadrez"
    , "Frango xadrez especial"
    , "Lombo frito"
    , "Macarrao chop-suei"
    , "Macarrao com camarao"
    , "Macarrao especial"
    , "Peixe apimentado"
    , "Peixe ao molho de gengibre"
    , "Peixe chop-suei"
    , "Porco agridoce"
    , "COMIDA ITALIANA"

    ,        "Agnelotti"
    ,        "Frango à milanesa"
    ,        "Gnochi"
    ,        "Lasanha ao sugo"
    ,        "Lasanha bolonhesa"
    ,        "Lasanha funghi"
    ,       "Molho Bella Don,a"
    ,      "Molho bolonhesa,"
    ,     "Ravioli"
    ,    "Azeite"
    ,   "Azeite de dendê"
    ,  "Bacon"
    , "Banha de porco"
    ,        "Creme de leite"
    ,        "Maionese"
    ,        "Manteiga"
    ,        "Margarina"
    ,        "Nutella"
    ,       "Oleo de dendê"
    ,       "Oleo de fígado de bacalhau"
    ,       "Oleos vegetais"
    ,       "Coraçao de boi"
    ,       "Cordeiro"
    ,       "Costela bovina cozida"
    ,       "Coxa de frango com pele"
    ,       "Coxa de frango sem pele"
    ,       "Dobradinha"
    ,       "Figado"
    ,       "Filé de frango grelhado"
    ,       "Frango (carne branca)"
    ,        "Frango (partes)"
    ,        "Hambúrguer (bovino)"
    ,        "Hambúrguer (chester)"
    ,        "Hambúrguer (frango)"
    ,        "Hambúrguer (peru)"
    ,        "Leitao"
    ,        "Língua"
    ,        "Lingúiça"
    ,        "Lombo de carneiro"
    ,      "Lombo suíno"
    ,      "Miúdos"
    ,      "Moela"
    ,      "Músculo bovino"
    ,      "Omelete com queijo"
    ,      "Omelete simples"
    ,      "Ovo (clara)"
        "Ovo (gema)"
    ,      "Ovo de codorna"
    ,       "Ovo de pata"
    ,       "Ovo inteiro"
    ,       "Ovo mexido"
    ,       "Pernil"
    ,       "Pernil assado"
    ,       "Pernil de cordeiro"
    ,       "Peru (carne branca)"
    ,        "Peru (partes)"
    ,        "Porco (lombo)"
    ,        "Porco (pernil)"
    ,        "Quibe assado"
    ,        "Rabada"
    ,        "Salsicha (chester)"
    ,      "Salsicha (frango)"
    ,   "Salsicha (peru)"
    ,  "Salsicha (suína)"
    , "Strogonoff"
    ,"Tender"
  ];

  String _data = "";
  String _textoConsulta = "";

  Future<StreamController<QuerySnapshot>?> _adicionarListenerRequisicoes()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    print("filtrando");
    _textoConsulta = _textoPesquisa.capitalizeFirst!;

    final stream = db.collection("Comidas")
        .where("titulo", isGreaterThanOrEqualTo: _textoConsulta)
        .snapshots();
    stream.listen((dados){_controler.add(dados);});
    User usuarioLogado = await auth.currentUser!;
    String _idUsuarioLogado;
  }

   List<dynamic> _listaCalorias = [];
  List<dynamic> _listaData = [];

  _recuperarDadosUsuario() async {
     String _idUsuarioLogado;
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .doc( _idUsuarioLogado )
        .get();

    Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
      setState(() {
        _calorias = dados!["calorias"];
        _listaCalorias = dados!["listaCalorias"];
        _listaData = dados!["listaData"];
        _idUsuarioLogado = usuarioLogado.uid;
        _dataUsuario = dados!["data"];
        print(dados!["nome"]);
        print(dados["data"]);

      });
      print("ACHAMOS A DATA");
      print(_dataUsuario);



     int _subsCalorias = _calorias;
     Map<String, dynamic>? dado = snapshot.data() as Map<String, dynamic>?;

     print("Adicionando Listas");
     _listaCalorias = dado!["listaCalorias"];
     _listaData = dado!["listaData"];
     //O PROBLEMA
     /*setState(() {

      if(Listacalorias[0] != null)
      _calorias = Listacalorias[0];
    });*/
     if(_listaData.isNotEmpty){
       for(int i = 0; i<_listaData.length; i++){

         listaGrafico.add(CaloricSeries(
           day: _listaData[i],
           calories: _listaCalorias[i],
           barColor: charts.ColorUtil.fromDartColor(Colors.blue),
         ));

       }

     }
     _data = DateTime.now().toString();
     initializeDateFormatting("pt_BR",null);
     var formatador = DateFormat("d/MM/yy");
     DateTime dataConvertida = DateTime.parse(_data);
     String dataormada = formatador.format(dataConvertida);
     _data = dataormada;
     print("TESTE 1");
     print(_data);
     print(_dataUsuario);
     if(_data!=_dataUsuario){
       if(listaGrafico.length>=5){
         _listaData.remove(_listaData[0]);
         _listaCalorias.remove(_listaCalorias[0]);

       }

       _listaData.add(_data);
       _listaCalorias.add(0);
       setState(() {
         _calorias = 0;
         _dataUsuario = _data;


       });
       Map<String, dynamic> dadosAtualizar = {
         "data" : _data,
         "calorias": 0,
         "listaData": _listaData,
         "listaCalorias": _listaCalorias

       };
       db.collection("usuarios")
           .doc(_idUsuarioLogado)
           .update( dadosAtualizar );
       snapshot = await db.collection("usuarios")
           .doc( _idUsuarioLogado )
           .get();



     }else{
       setState(() {

       });
     }

  }
  String _falta(int _obj, int _total){
    if(_total>_obj){
      return "Já se passaram ${_total-_obj} calorias da meta diária." ;
    }else{
      return "Ainda faltam ${_obj-_total} calorias para a meta diária";
    }
  }
  int _caloriasMomentaneas = 0;
  _alterarCalorias(int _inicial, int _final,int preco )async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User usuarioLogado = await auth.currentUser!;
    String _idUsuarioLogado;
    _idUsuarioLogado = usuarioLogado.uid;
    _data = DateTime.now().toString();
    initializeDateFormatting("pt_BR",null);
    var formatador = DateFormat("d/MM/yy");
    DateTime dataConvertida = DateTime.parse(_data);
    String dataormada = formatador.format(dataConvertida);
    _data = dataormada;

    _calorias = _calorias - _inicial*preco;
    _caloriasMomentaneas = _caloriasMomentaneas - _inicial*preco;
    setState(() {
      _caloriasMomentaneas = _caloriasMomentaneas + _final*preco;
      _calorias = _calorias + _final*preco;
    });
    print("CALORIAS MOMENTANEAS");
    print(_caloriasMomentaneas);
    _listaCalorias[_listaCalorias.length-1] = _calorias;
    print(_listaData[_listaData.length-1]);
    _listaData[_listaData.length-1] = _data;
    Map<String, dynamic> dadosAtualizar = {
      "data" : _data,
      "calorias": _calorias,
      "listaCalorias" : _listaCalorias,
      "listaData": _listaData

    };
    db.collection("usuarios")
        .doc(_idUsuarioLogado)
        .update( dadosAtualizar );
    _adicionarListenerRequisicoes();
  }

  _introduzirComidas(){
    for(int i = 0; i<_alimentacios.length; i++){
      _foodController.addFood(_alimentacios[i]);
    }

  }
  _grafico()async{


      if(_listaData.isNotEmpty){

        for(int i = 0; i<_listaData.length; i++){

            listaGrafico.add(CaloricSeries(
              day: _listaData[i],
              calories: _listaCalorias[i],
              barColor: charts.ColorUtil.fromDartColor(Colors.blue),
            )
            );
        }
      }

}



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _grafico();
    _introduzirComidas();
    _adicionarListenerRequisicoes();
    _recuperarDadosUsuario();

  }




  @override

  Widget build(BuildContext context) {

    _exibirTela(){

      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(

              title: Text("Histórico"),
              content: Column(
                mainAxisSize: MainAxisSize.max,


                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 500)),

                  Text("Seu histórico é atualizado a cada dia:"),
                  SubscriberChart(data: listaGrafico, )






                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar")
                ),
              ],
            );
          }
      );

    }
    _exibirNota(String titulo, String descricao){

      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text(titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(descricao, style: TextStyle(fontSize: 16,),),

                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () => Navigator.pop(context),

                    child: Text("Sair")
                ),

              ],
            );
          }
      );

    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Alimentos"),),
      body: Container(
        child:

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(padding:EdgeInsets.only(top: 5, left: 12, bottom: 12),
              child: Text("Aqui você pode adicionar metas e acompanhar suas calorias diárias", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
              ),),


                Padding(padding:EdgeInsets.only(top: 5, left: 12),
                  child: Text("Pontos de caloria totais hoje: $_calorias", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                  ),),
            Padding(padding:EdgeInsets.only(top: 2, left: 12, bottom: 10),
              child: Text("(1 ponto equivale a 3,6 calorias)", style: TextStyle(fontSize: 12),
              ),),


              Padding(padding:EdgeInsets.only(top: 8, left: 12, bottom: 3),
                child: Text("Objetivo:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),),
              Padding(
                padding: EdgeInsets.only(bottom: 5, left: 18, right: 18),
                child: TextField(
                  controller: _controllerDes,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16),
                  onChanged: (texto){
                    setState(() {
                      _meta = int.parse(texto);
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 8, 8, 16),
                      hintText: "Ex: 90",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
              ),





            Padding(padding:EdgeInsets.only(bottom: 7, left: 12, top: 3),
              child: Text(_falta(_meta, _calorias), style: TextStyle(fontSize: 14),
              ),),
            Padding(padding:EdgeInsets.only(top: 5, left: 12),
              child: Text("Filtrar alimentos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),),
            Padding(
              padding: EdgeInsets.only(bottom: 8, left: 18, right: 18),
              child: TextField(
                controller: _pesquisa,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18),
                onChanged: (texto){

                  setState(() {
                    _textoPesquisa = texto;
                  });
                  _adicionarListenerRequisicoes();
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 8, 16),
                    hintText: "Ex: Chocolate",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32))),
              ),
            ),

            Flexible(child:StreamBuilder<QuerySnapshot>

              (stream: _controler.stream, builder:(context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Padding(padding: EdgeInsets.all(12), child: Text(" Espere só um pouco...",),);
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  if(snapshot.hasError){
                    return Text("Erro ao Carregar os Dados");
                  }else{
                    QuerySnapshot? querySnapshot = snapshot.data;
                    if(querySnapshot!.docs.length ==0){
                      return Padding(
                          padding: EdgeInsets.only(left: 12, top: 12, bottom: 16),
                          child:
                          Column(
                            children: <Widget>[
                              Text("Não encontramos nenhum alimento na base de dados :/"

                                ,
                                style: TextStyle( fontSize: 16),


                              ) ,
                            ],
                          )

                      );
                    }else {

                      return
                        SizedBox(
                          height: 220,

                          child: ListView.separated(
                            itemCount: querySnapshot.docs.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(24),

                            primary: false,
                            shrinkWrap: true,
                            separatorBuilder: (context, indice) => Divider( color:  Colors.white, indent: 16,),
                            itemBuilder: (context, indice){
                              List<DocumentSnapshot> requisicoes = querySnapshot.docs.toList();
                              DocumentSnapshot item = requisicoes[indice];
                              String titulo = item["titulo"];
                              int preco = item["calorias"];
                              String unidade = item["unidade"];


                              return
                                GestureDetector(

                                    onTap: (){},
                                    child: Container(

                                    child: Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(12, 12, 12, 30),
                                          child:
                                          Column(
                                            children: [
                                              Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                              Text(
                                                titulo,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,

                                                ),
                                              )

                                                ,),
                                              Row(
                                                children: [
                                                  Padding(padding: EdgeInsets.all(12),
                                                    child: Icon(Icons.fastfood, color: Colors.blue, size: 50,),


                                                  ),
                                                  Column(
                                                    children: [

                                                      Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                      Text(
                                                        " A cada $unidade",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blueAccent
                                                        ),
                                                      )

                                                        ,),
                                                      Padding(padding: EdgeInsets.only(left: 12, right: 12, ), child:
                                                      Text(
                                                        "Calorias: $preco",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blueAccent
                                                        ),
                                                      )

                                                        ,),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                      child: Icon(Icons.add_circle, color: Colors.blue, ) ,
                                                      onTap:  (){

                                                        _foodController.addFood(titulo);

                                                        _alterarCalorias(_foodController.foods[titulo]-1, _foodController.foods[titulo], preco);
                                                      }
                                                  ),
                                                  Padding(padding: EdgeInsets.only(left: 12, right: 12, ), child:
                                                  Obx(()=>Text(
                                                    "${_foodController.foods[titulo]}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blueAccent
                                                    ),
                                                  ))


                                                    ,),
                                                  GestureDetector(
                                                      child: Icon(Icons.remove_circle, color: Colors.blue, ) ,
                                                      onTap:  (){
                                                        _foodController.dimFoods(titulo);
                                                        if(_calorias>=preco){_alterarCalorias(_foodController.foods[titulo]+1, _foodController.foods[titulo], preco);}

                                                      }
                                                  ),

                                                ],
                                              )


                                            ],


                                          )
                                          ,

                                        )
                                    )
                                    )
                                );



                            },


                          ),
                        );
                      break;
                    }

                  }
              }



            }

              ,
            ),  ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [GestureDetector(
                  onTap: _exibirTela,
                  child: Container(

                    width: 300,

                    child: Text(
                      "Exibir Histórico",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),

                    ),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(30), ),
                  ),
                ),] )











          ],
        ),
      ),

    );
  }
}
