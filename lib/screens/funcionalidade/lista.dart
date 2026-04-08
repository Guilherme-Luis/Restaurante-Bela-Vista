import 'package:flutter/material.dart';
import '../../models/modelo_principal.dart';
import 'formulario.dart';

class ListaPedidos extends StatefulWidget {
  final List<Pedido> _pedidos = [];

  @override
  State<StatefulWidget> createState() {
    return ListaPedidosState();
  }
}

class ListaPedidosState extends State<ListaPedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurante Bela Vista'),
      ),
      body: ListView.builder(
        itemCount: widget._pedidos.length,
        itemBuilder: (context, indice) {
          final pedido = widget._pedidos[indice];
          return ItemPedido(
            pedido,
            onDelete: () {
              setState(() {
                widget._pedidos.removeAt(indice);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const FormularioPedido();
              },
            ),
          ).then((pedidoRecebido) => _atualiza(pedidoRecebido));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _atualiza(Pedido? pedidoRecebido) {
    if (pedidoRecebido != null) {
      setState(() {
        widget._pedidos.add(pedidoRecebido);
      });
    }
  }
}

class ItemPedido extends StatelessWidget {
  final Pedido _pedido;
  final VoidCallback onDelete;

  const ItemPedido(this._pedido, {required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant),
        title: Text(_pedido.prato),
        subtitle: Text('R\$ ${_pedido.valor.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
