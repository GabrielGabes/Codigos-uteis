################################################################################
# Funções rodando em fila
import schedule

# Agendamentos
schedule.every(5).minutes.do(lambda: pesquisa_completa('cryptos'))
schedule.every().hour.at(":00").do(salvando_planilha_registros)

while True:
    schedule.run_pending()  # Executa a próxima função agendada, se houver
    time.sleep(1)           # Aguarda 1 segundo antes de verificar novamente
    
################################################################################
# As funções rodam em paralelo, não bloqueando uma à outra.
import schedule
import threading
import time

def run_threaded(job_func):
    job_thread = threading.Thread(target=job_func)
    job_thread.start()

schedule.every(15).minutes.do(run_threaded, analise)
schedule.every().hour.at(":00").do(run_threaded, rotina)

print("⏱ Iniciando scheduler...")

while True:
    schedule.run_pending()
    time.sleep(1)
