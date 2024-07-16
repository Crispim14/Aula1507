import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalaRepete extends StatefulWidget {
  const SalaRepete({super.key});

  @override
  _SalaRepeteState createState() => _SalaRepeteState();
}

class _SalaRepeteState extends State<SalaRepete> {
  List<Sala> salas = [];
  Sala? salaAtual;

  void criarSala() {
    setState(() {
      salas
          .add(Sala('Sala ${salas.length + 1}', 'Jogador ${salas.length + 1}'));
      salaAtual = salas.last;
    });
  }

  void entrarSala(Sala sala) {
    setState(() {
      sala.jogadores.add('Jogador ${sala.jogadores.length + 1}');
      salaAtual = sala;
    });
  }

  void sairSala() {
    setState(() {
      salaAtual = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return salaAtual == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: criarSala,
                child: const Text('Criar Sala'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: salas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(salas[index].nome),
                      onTap: () => entrarSala(salas[index]),
                    );
                  },
                ),
              ),
            ],
          )
        : JogoRepeteComSala(sala: salaAtual!, sairSala: sairSala);
  }
}

class JogoRepeteComSala extends StatefulWidget {
  final Sala sala;
  final VoidCallback sairSala;

  const JogoRepeteComSala(
      {required this.sala, required this.sairSala, super.key});

  @override
  _JogoRepeteComSalaState createState() => _JogoRepeteComSalaState();
}

class _JogoRepeteComSalaState extends State<JogoRepeteComSala> {
  int pontos = 0;
  String imagemDado = '';
  String mensagem = 'Role o dado!';
  int jogadorAtual = 0;
  int valorDadoAnterior = 0;

  Future<void> rolarDado() async {
    var url = Uri.https(
        '89251fa1-c1cc-432f-a9c6-f40c20048c08-00-fbjdp3ey1vbj.spock.replit.dev');

    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      var respostaJSON = jsonDecode(resposta.body);
      int valorDado = int.parse(respostaJSON['dado']);
      String imagem = respostaJSON['imagem'];

      setState(() {
        imagemDado = imagem;
        if (valorDado == 5) {
          mensagem = 'Rolou 5: Repete sem somar pontos.';
        } else if (valorDado == 1 || valorDado == 3) {
          mensagem = 'Rolou $valorDado: Perdeu a vez.';
          proximoJogador();
        } else {
          if (valorDadoAnterior == valorDado) {
            pontos += valorDado;
            mensagem = 'Rolou $valorDado: Soma pontos e repete!';
          } else {
            pontos += valorDado;
            mensagem = 'Rolou $valorDado: Pontos somados.';

            if (pontos == 10) {
              mensagem = 'Ganhou!';
              encerrarSala();
            } else if (pontos > 10) {
              mensagem = 'Perdeu!';
              proximoJogador();
            }
          }
        }
        valorDadoAnterior = valorDado;
      });
    } else {
      setState(() {
        mensagem = 'Erro ao rolar o dado!';
      });
    }
  }

  void proximoJogador() {
    setState(() {
      jogadorAtual = (jogadorAtual + 1) % widget.sala.jogadores.length;
      pontos = 0;
      imagemDado = '';
      valorDadoAnterior = 0;
    });
  }

  void encerrarSala() {
    setState(() {
      widget.sala.encerrada = true;
      widget.sala.resultado = 'Jogador ${jogadorAtual + 1} ganhou!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Sala: ${widget.sala.nome}'),
        Text('Jogador Atual: ${widget.sala.jogadores[jogadorAtual]}'),
        if (widget.sala.encerrada) Text(widget.sala.resultado!),
        if (!widget.sala.encerrada)
          Column(
            children: [
              if (imagemDado.isNotEmpty) Image.network(imagemDado, height: 100),
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
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: widget.sairSala,
            child: const Text('Sair da Sala'),
          ),
        ),
      ],
    );
  }
}

class Sala {
  final String nome;
  final List<String> jogadores;
  bool encerrada;
  String? resultado;

  Sala(this.nome, String jogadorInicial)
      : jogadores = [jogadorInicial],
        encerrada = false,
        resultado = null;
}
