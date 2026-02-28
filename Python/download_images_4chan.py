import os
import time
import requests
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

# =========================
# PARÂMETROS AJUSTÁVEIS
# =========================
MAX_RETRIES = 3
BACKOFF_BASE = 1.5     # fator de espera entre tentativas
CHUNK_SIZE = 1024 * 256  # 256 KB por chunk
MIN_SIZE_BYTES = 5_000  # ignora arquivos muito pequenos (provável erro)

# =========================
# FUNÇÕES DE SUPORTE
# =========================
def ensure_dir(path: str) -> str:
    path = os.path.abspath(path.strip().strip('"').strip("'") or "downloads")
    os.makedirs(path, exist_ok=True)
    return path

def is_likely_image_content_type(ct: str) -> bool:
    if not ct:
        return True  # às vezes o servidor não envia, não bloqueie por isso
    return ct.lower().startswith("image/")

def has_valid_magic_signature(file_path: str) -> bool:
    """
    Verifica assinaturas básicas: JPEG, PNG, GIF, WEBP.
    Suficiente para detectar truncamentos óbvios.
    """
    try:
        with open(file_path, "rb") as f:
            head = f.read(16)
        # JPEG
        if head.startswith(b"\xFF\xD8\xFF"):
            return True
        # PNG
        if head.startswith(b"\x89PNG\r\n\x1a\n"):
            return True
        # GIF
        if head.startswith(b"GIF87a") or head.startswith(b"GIF89a"):
            return True
        # WEBP: RIFF....WEBP (bytes 0-3 'RIFF', 8-11 'WEBP')
        if head[:4] == b"RIFF" and head[8:12] == b"WEBP":
            return True
        # Se não reconheceu, pode ainda ser imagem (bmp, tiff etc.) – deixe passar?
        # Aqui optamos por exigir uma das principais extensões para 4chan:
        return False
    except Exception:
        return False

def valid_download(path: str, expected_len: int | None) -> bool:
    # Tamanho mínimo
    try:
        size = os.path.getsize(path)
    except FileNotFoundError:
        return False
    if size < MIN_SIZE_BYTES:
        return False
    # Se Content-Length veio, compare
    if expected_len and expected_len > 0 and size != expected_len:
        # Permite pequena diferença? Em HTTP deve casar exato; se não casar, trate como inválido
        return False
    # Verificação de assinatura mágica
    if not has_valid_magic_signature(path):
        return False
    return True

def download_with_retries(session: requests.Session, url: str, dest_path: str) -> bool:
    # Se já existe, tente validar primeiro (evita re-download)
    if os.path.exists(dest_path):
        if valid_download(dest_path, None):
            return True
        else:
            try:
                os.remove(dest_path)
            except Exception:
                pass

    last_err = None
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            resp = session.get(url, timeout=30, stream=True)
            status = resp.status_code
            if status != 200:
                last_err = f"HTTP {status}"
                raise RuntimeError(last_err)

            ct = resp.headers.get("Content-Type", "")
            if not is_likely_image_content_type(ct):
                last_err = f"Content-Type inesperado: {ct}"
                raise RuntimeError(last_err)

            expected_len = resp.headers.get("Content-Length")
            expected_len = int(expected_len) if (expected_len and expected_len.isdigit()) else None

            tmp_path = dest_path + ".partial"
            with open(tmp_path, "wb") as f:
                for chunk in resp.iter_content(chunk_size=CHUNK_SIZE):
                    if chunk:
                        f.write(chunk)

            # Renomeia para definitivo
            if os.path.exists(dest_path):
                try:
                    os.remove(dest_path)
                except Exception:
                    pass
            os.replace(tmp_path, dest_path)

            # Validação pós-download
            if valid_download(dest_path, expected_len):
                return True
            else:
                last_err = "Arquivo inválido (assinatura/tamanho)"
                # apaga para próxima tentativa
                try:
                    os.remove(dest_path)
                except Exception:
                    pass

        except Exception as e:
            last_err = str(e)
            # Limpeza de temporários
            try:
                if os.path.exists(dest_path + ".partial"):
                    os.remove(dest_path + ".partial")
            except Exception:
                pass

        # Backoff entre tentativas
        if attempt < MAX_RETRIES:
            sleep_s = BACKOFF_BASE ** attempt
            time.sleep(sleep_s)

    # Se chegou aqui, falhou todas tentativas — garanta que não fique lixo
    try:
        if os.path.exists(dest_path):
            os.remove(dest_path)
    except Exception:
        pass
    print(f"   ↳ Falhou após {MAX_RETRIES} tentativas: {last_err}")
    return False

# =========================
# ENTRADAS DO USUÁRIO
# =========================
URL = input("Digite o endereço da thread (ex: https://boards.4chan.org/wg/thread/...): ").strip().strip('"').strip("'")
if not URL.startswith(("http://", "https://")):
    raise ValueError("❌ URL inválida! Ela deve começar com http:// ou https://")

PASTA_DOWNLOAD = ensure_dir(input("Digite a pasta onde os arquivos serão salvos (ou Enter para ./downloads): "))

print(f"\n✅ Thread: {URL}")
print(f"✅ Pasta de download: {PASTA_DOWNLOAD}\n")

# =========================
# SELENIUM – CAPTURA DE LINKS
# =========================
browser = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
browser.get(URL)
time.sleep(3)

# Pega todos os links das imagens em tamanho real
thumbs = browser.find_elements(By.CSS_SELECTOR, "a.fileThumb")
links = [a.get_attribute("href") for a in thumbs if a.get_attribute("href")]
print(f"Encontradas {len(links)} imagens para baixar...")

# =========================
# DOWNLOAD COM VALIDAÇÃO/RETRY
# =========================
session = requests.Session()
session.headers.update({
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Python-requests Downloader"
})

ok_count = 0
fail_count = 0

for i, img_url in enumerate(links, start=1):
    filename = os.path.join(PASTA_DOWNLOAD, img_url.split("/")[-1])
    # filename = os.path.join(PASTA_DOWNLOAD, os.path.basename(img_url))

    print(f"[{i}/{len(links)}] Baixando filename: {filename}")
    # print(f"img_url: {img_url} \n")

    if download_with_retries(session, img_url, filename):
        ok_count += 1
    else:
        fail_count += 1

browser.quit()
print(f"\n✅ Concluído. Sucesso: {ok_count} | Falhas: {fail_count}")
