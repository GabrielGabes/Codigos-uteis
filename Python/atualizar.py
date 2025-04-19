import subprocess
import pkg_resources

# Obtém a lista de todos os pacotes instalados
packages = [dist.project_name for dist in pkg_resources.working_set]

# Atualiza cada pacote usando pip
for package in packages:
    subprocess.call(f"pip install --upgrade {package}", shell=True)

print('oi')