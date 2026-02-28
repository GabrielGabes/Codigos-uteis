import os
from collections import defaultdict

def get_size(path):
    """Retorna o tamanho de um arquivo ou pasta em bytes."""
    if os.path.isfile(path):
        return os.path.getsize(path)
    total_size = 0
    for dirpath, _, filenames in os.walk(path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            try:
                total_size += os.path.getsize(fp)
            except FileNotFoundError:
                pass
    return total_size

def report_heaviest(base_dir, top_n=10):
    folder_sizes = defaultdict(int)
    file_sizes = []

    # Percorre o diretório
    for dirpath, dirnames, filenames in os.walk(base_dir):
        # Calcula tamanho das pastas
        folder_sizes[dirpath] = get_size(dirpath)
        # Calcula tamanho dos arquivos
        for f in filenames:
            fp = os.path.join(dirpath, f)
            try:
                size = os.path.getsize(fp)
                file_sizes.append((fp, size))
            except FileNotFoundError:
                pass

    # Ordena por tamanho
    top_folders = sorted(folder_sizes.items(), key=lambda x: x[1], reverse=True)[:top_n]
    top_files = sorted(file_sizes, key=lambda x: x[1], reverse=True)[:top_n]

    print("\n=== Pastas mais pesadas ===")
    for folder, size in top_folders:
        print(f"{folder}: {size/1024/1024:.2f} MB")

    print("\n=== Arquivos mais pesados ===")
    for file, size in top_files:
        print(f"{file}: {size/1024/1024:.2f} MB")

if __name__ == "__main__":
    base_dir = r"C:\Users\gabri\OneDrive"
    report_heaviest(base_dir, top_n=20)