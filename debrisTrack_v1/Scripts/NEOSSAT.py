import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

def download_fits(url):
    response = requests.get(url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.content, "html.parser")
        links = soup.find_all("a", href=True)

        for link in links:
            file_url = urljoin(url, link["href"])
            if file_url.endswith(".fits"):
                file_name = os.path.basename(file_url)
                print(f"Descargando: {file_name}")
                with open(file_name, "wb") as file:
                    response_file = requests.get(file_url)
                    file.write(response_file.content)
                print(f"Descarga completada: {file_name}")

if __name__ == "__main__":
    url = input("Ingresa la URL del directorio que contiene los archivos FITS: ")
    download_fits(url)