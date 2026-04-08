class Pedido {
  final String prato;
  final double valor;

  Pedido(this.prato, this.valor);

  @override
  String toString() {
    return 'Pedido{prato: $prato, valor: $valor}';
  }
}
