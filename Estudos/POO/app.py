from geladeira import Geladeira

geladeira_danone = Geladeira('danone', 6)
geladeira_danone.receber_observacao('azedo')
geladeira_yorgute = Geladeira('yorgute', 6)
geladeira_danone.receber_observacao('doce demais')

def main():
    geladeira.lista_produtos()

if __name__ == '__main__':
    main()