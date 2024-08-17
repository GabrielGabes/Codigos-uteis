import random
import string

def gerar_palavra_aleatoria(tamanho_maximo=10):
    tamanho = random.randint(2, tamanho_maximo)  # Ajuste para pelo menos 2 para garantir espaço para uma letra e um dígito
    letras = string.ascii_letters
    numeros = string.digits
    
    # Garante que tenha pelo menos uma letra e um número
    palavra = [random.choice(letras), random.choice(numeros)]
    
    # Preenche o restante da palavra aleatoriamente com letras ou números
    for _ in range(tamanho - 2):
        escolha = random.choice(letras + numeros)
        palavra.append(escolha)

    # Embaralha os caracteres para que o número não fique necessariamente na segunda posição
    random.shuffle(palavra)
    
    return ''.join(palavra)

print(gerar_palavra_aleatoria())