import psutil
import platform
import GPUtil

# Informações do sistema
print("Sistema:", platform.system())
print("Versão:", platform.version())
print("Arquitetura:", platform.architecture())

# CPU
print("\n--- CPU ---")
print("Processador:", platform.processor())
print("Núcleos físicos:", psutil.cpu_count(logical=False))
print("Núcleos lógicos:", psutil.cpu_count(logical=True))
print("Uso atual da CPU (%):", psutil.cpu_percent(interval=1))

# Memória RAM
print("\n--- Memória RAM ---")
mem = psutil.virtual_memory()
print("Total:", round(mem.total / (1024**3), 2), "GB")
print("Disponível:", round(mem.available / (1024**3), 2), "GB")
print("Uso (%):", mem.percent)

# GPU
print("\n--- GPU ---")
gpus = GPUtil.getGPUs()
for gpu in gpus:
    print("Nome:", gpu.name)
    print("Memória total:", f"{gpu.memoryTotal} MB")
    print("Memória usada:", f"{gpu.memoryUsed} MB")
    print("Memória livre:", f"{gpu.memoryFree} MB")
    print("Uso (%):", gpu.load * 100)
    print("Temperatura:", gpu.temperature, "°C")