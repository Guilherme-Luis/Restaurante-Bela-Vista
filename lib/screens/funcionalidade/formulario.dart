import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/editor.dart';
import '../../models/modelo_principal.dart';

class FormularioPedido extends StatefulWidget {
  const FormularioPedido({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormularioPedidoState();
  }
}

class FormularioPedidoState extends State<FormularioPedido> {
  final TextEditingController _controladorCampoPrato = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController(text: 'R\$ 0,00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoPrato,
              rotulo: 'Nome do Prato',
              dica: 'Ex: Pizza, Hambúrguer',
              icone: Icons.restaurant_menu,
              formatadores: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\sÀ-ÿ]')),
              ],
            ),
            Editor(
              controlador: _controladorCampoValor,
              rotulo: 'Valor',
              dica: 'R\$ 0,00',
              icone: Icons.monetization_on,
              teclado: TextInputType.number,
              formatadores: [
                MoedaInputFormatter(),
              ],
            ),
            ElevatedButton(
              child: const Text('Confirmar'),
              onPressed: () => _criaPedido(context),
            ),
          ],
        ),
      ),
    );
  }

  void _criaPedido(BuildContext context) {
    final String prato = _controladorCampoPrato.text;
    
    // Extrai o valor numérico da máscara para salvar no modelo
    String valorLimpo = _controladorCampoValor.text
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
        
    final double? valor = double.tryParse(valorLimpo);

    if (prato.isNotEmpty && valor != null && valor > 0) {
      final pedidoCriado = Pedido(prato, valor);
      Navigator.pop(context, pedidoCriado);
    }
  }
}

class MoedaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Remove tudo que não for número
    String apenasNumeros = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (apenasNumeros.isEmpty) {
      return newValue.copyWith(
        text: 'R\$ 0,00',
        selection: const TextSelection.collapsed(offset: 7),
      );
    }

    double valorFinal = double.parse(apenasNumeros) / 100;

    // Aplica o limite máximo de 10.000,00
    if (valorFinal > 10000.0) {
      valorFinal = 10000.0;
    }

    // Formata manualmente para R$ X.XXX,XX
    String novoTexto = 'R\$ ' + _formatarParaMoeda(valorFinal);

    return newValue.copyWith(
      text: novoTexto,
      selection: TextSelection.collapsed(offset: novoTexto.length),
    );
  }

  String _formatarParaMoeda(double valor) {
    List<String> partes = valor.toStringAsFixed(2).split('.');
    String inteiro = partes[0];
    String decimal = partes[1];

    final buffer = StringBuffer();
    int contador = 0;
    for (int i = inteiro.length - 1; i >= 0; i--) {
      if (contador > 0 && contador % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(inteiro[i]);
      contador++;
    }
    
    String inteiroFormatado = buffer.toString().split('').reversed.join();
    return '$inteiroFormatado,$decimal';
  }
}
