class Geladeira:
    observacoes = []

    def __init__(self, nome, qtd):
        self._nome = nome.title()
        self._qtd = str(qtd)
        self._ativo = False
        self._obs = []
        Geladeira.observacoes.append(self)

    def __str__(self):
        return f'{self._nome} | {self._qtd}'

    @classmethod
    def lista_produtos(cls):
        print(f'{'Nome do produto'.ljust(25)} | {'qtd'.ljust(25)} | |{'Status'}')
        for observacoes in cls.observacoes:
            print(f'{observacoes._nome.ljust(25)} | {observacoes._qtd.ljust(25)} | |{observacoes.ativo}')

    @property
    def ativo(self):
        return '⌧' if self._ativo else '☐'

    def alternar_estado(self):
        self._ativo = not self._ativo

    def receber_observacao(self, observacao):
        self._obs.append(observacao)

geladeira_danone = Geladeira('danone', 6)
geladeira_danone.receber_observacao('azedo')
geladeira_yorgute = Geladeira('yorgute', 6)
geladeira_danone.receber_observacao('doce demais')

def main():
    Geladeira.lista_produtos()

if __name__ == '__main__':
    main()