import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RespostaEstado extends StatefulWidget {
  const RespostaEstado({super.key});

  @override
  State<RespostaEstado> createState() => _RespostaEstadoState();
}

class _RespostaEstadoState extends State<RespostaEstado> {
  @override
  Widget build(BuildContext context) {
    var texto = geraSaida();
    return Column(
      children: [
        texto,
        ElevatedButton(
          onPressed: () {
            setState(() {
              texto = geraSaida();
            });
          },
          child: const Text('novo!'),
        ),
      ],
    );
  }

  FutureBuilder<String> geraSaida() {
    return FutureBuilder(
        future: buscaTexto(),
        builder: (context, registro) {
          if (registro.hasData) {
            return Text(
              registro.data!,
              style: const TextStyle(
                fontSize: 48,
              ),
            );
          } else if (registro.hasError) {
            return const Text('Houve um erro');
          }
          return const CircularProgressIndicator();
        });
  }

  Future<String> buscaTexto() async {
    var url = Uri.https(
        '89251fa1-c1cc-432f-a9c6-f40c20048c08-00-fbjdp3ey1vbj.spock.replit.dev');

    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      var respostaJSON = jsonDecode(resposta.body);
      print(resposta.body);
      return respostaJSON['dado'];
    } else {
      print('Falha com estado: ${resposta.statusCode}.');
      return 'erro';
    }
  }
}
