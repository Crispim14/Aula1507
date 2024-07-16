import 'package:flutter/material.dart';
import 'dart:math';

class JogoRepete extends StatefulWidget {
  const JogoRepete({super.key});

  @override
  _JogoRepeteState createState() => _JogoRepeteState();
}

class _JogoRepeteState extends State<JogoRepete> {
  int pontos = 0;
  int valorDadoAnterior = 0;
  String mensagem = 'Role o dado!';

  void rolarDado() {
    int valorDado = Random().nextInt(6) + 1;
    setState(() {
      if (valorDado == 5) {
        mensagem = 'Rolou 5: Repete sem somar pontos.';
      } else if (valorDado == 1 || valorDado == 3) {
        mensagem = 'Rolou $valorDado: Perdeu a vez.';
        pontos = 0;
      } else {
        if (valorDado == valorDadoAnterior) {
          pontos += valorDado;
          mensagem = 'Rolou $valorDado: Soma pontos e repete!';
        } else {
          pontos += valorDado;
          mensagem = 'Rolou $valorDado: Pontos somados.';

          if (pontos == 10) {
            mensagem = 'Ganhou!';
          } else if (pontos > 10) {
            mensagem = 'Perdeu!';
            pontos = 0;
          }
        }
      }
      valorDadoAnterior = valorDado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Pontos: $pontos',
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 20),
        Text(
          mensagem,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: rolarDado,
          child: const Text('Rolar Dado'),
        ),
      ],
    );
  }
}
