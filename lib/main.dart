import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_app/splash.dart';

import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
      initialRoute: '/',
      routes: {
        '/segundaTela': (context) => segundaTela(),
      },
    );
  }
}
class segundaTela extends StatefulWidget {
  segundaTela({Key key}) : super(key: key);
  @override
  _segundaTela createState() => _segundaTela();
}

class _segundaTela extends State {
  var _currentPage = 0;
  var _pages = [
    Perfil(),
    Aulas(),
    calc()
  ];
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(child: _pages.elementAt(_currentPage)),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Meu perfil"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.sticky_note_2),
                  label: "Anotações"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calculate),
                  label: "Calculadora"),
            ],
            currentIndex: _currentPage,
            onTap: (int inIndex) {
              setState(() {
                _currentPage = inIndex;
              });
            }),
      ),
    );
  }
}


class Aulas extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
        ),
        body: Container(
            child:
            Form(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 29,
                  ),
                  RaisedButton(
                    child: Text("Salvar"),
                    onPressed: null,
                  )
                ],
              ),
            )
        )
    );
  }
}

class Perfil extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
        ),
        body: Center(
          child: Text('Tela com as informações da pessoa'),
        )
    );
  }
}
typedef OperadorFunc = double Function(double valor, double operando);

class calc extends StatefulWidget {
  @override
  MyAppState createState() {return new MyAppState();}
}
class MyAppState extends State<calc> {

  double valor = 0.0;
  double operando = 0.0;
  OperadorFunc filadeOperacao;
  String resultadoString = "0.0";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        debugShowCheckedModeBanner: false,
        home: SafeArea(

          child: Material(color: Colors.white,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(

                    child:
                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                        [
                          Text(resultadoString,textAlign: TextAlign.right,
                            style:
                            TextStyle(fontSize: 50.0, color: Colors.black),
                          )
                        ]
                    )
                ),
                buildRow(3,7,1,"/", (valor, divisor)=> valor / divisor , 1),
                buildRow(3,4,1,"x", (valor, divisor)=> valor * divisor , 1),
                buildRow(3,1,1,"-", (valor, divisor)=> valor - divisor , 1),
                buildRow(1,0,3,"+", (valor, divisor)=> valor + divisor , 1),
                Expanded(
                  child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,children:
                  [buildOperadorBotoes("C", null, 1, color: Colors.blueGrey),
                    buildOperadorBotoes("=", (valor, divisor)=> valor, 3)],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  void numeroPressionado(int valor)  {
    operando = operando * 10 + valor;
    setState(
            () => resultadoString = operando.toString()
    );
  }

  void calcular(OperadorFunc operacao) {
    if (operacao == null) {
      valor = 0.0;
    }else{
      valor = filadeOperacao != null ? filadeOperacao(valor, operando) : operando;
    }
    filadeOperacao = operacao;
    operando = 0.0;
    var resultado = valor.toString();
    setState(
            () => resultadoString = resultado.toString().substring(0, min(10,resultado.length))
    );
  }

  buildNumeroBotoes( int count,int from, int flex) {
    return Iterable.generate(count, (index)
    {
      return Expanded(flex: flex,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: FlatButton(
              onPressed: () => numeroPressionado(from + index), color: Colors.white,
              child:
              Text("${from + index}",
                style: TextStyle(fontSize: 40.0),
              )
          ),
        ),
      );
    }).toList();
  }

  buildOperadorBotoes(String label, OperadorFunc func,
      int flex, {Color color = Colors.lightBlueAccent}){
    return Expanded(flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: FlatButton(onPressed: () => calcular(func), color: color,
            child: Text(
              label,
              style: TextStyle(fontSize: 40.0),
            )
        ),
      ),
    );
  }

  buildRow(int numberKeyCount, int startNumber,  int numberFlex, String operationLabel,
      OperadorFunc operacao, int operrationFlex){
    return Expanded(child:
    Row(crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.from(
            buildNumeroBotoes(numberKeyCount,startNumber ,numberFlex,)
        )
          ..add(
              buildOperadorBotoes(operationLabel, operacao, operrationFlex)
          )
    )
    );
  }
}
