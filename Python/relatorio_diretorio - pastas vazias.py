import os

def find_empty_folders(base_dir):
    empty_folders = []
    for dirpath, dirnames, filenames in os.walk(base_dir):
        # Se não há arquivos nem subpastas, é uma pasta vazia
        if not dirnames and not filenames:
            empty_folders.append(dirpath)
    return empty_folders

if __name__ == "__main__":
    base_dir = r"C:\Users\gabri\OneDrive\Documentos"
    empty_folders = find_empty_folders(base_dir)

    print("\n=== Pastas vazias encontradas ===")
    if empty_folders:
        for folder in empty_folders:
            print(folder)
    else:
        print("Nenhuma pasta vazia encontrada.")