import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Cep {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  Cep({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController cepController = TextEditingController();
  List<Cep> ceps = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta e Cadastro de CEPs'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: cepController,
            decoration: InputDecoration(labelText: 'CEP'),
          ),
          ElevatedButton(
            onPressed: () {
              consultarCEP(cepController.text);
            },
            child: Text('Consultar CEP'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ceps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('CEP: ${ceps[index].cep}'),
                  subtitle: Text('Cidade: ${ceps[index].localidade}, UF: ${ceps[index].uf}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> consultarCEP(String cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cepData = Cep(
        cep: data['cep'],
        logradouro: data['logradouro'],
        bairro: data['bairro'],
        localidade: data['localidade'],
        uf: data['uf'],
      );

      setState(() {
        ceps.add(cepData);
      });
    } else {
      // Lida com o erro ao consultar o CEP
    }
  }
}

