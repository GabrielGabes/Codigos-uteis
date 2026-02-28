# usar quando importar funções de algum arquivo e precisar atualizar o arquivo e reimportar as funções
import sys
sys.modules.pop('indicadores.tendencia2', None)