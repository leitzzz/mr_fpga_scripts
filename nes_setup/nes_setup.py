#!/usr/bin/python3

from datetime import datetime

import zipfile
import os
import math
import requests  # pylint: disable=import-error

DIRECTORY_DESTINATION = "/media/fat/games/NES/"

JSON_URL = "https://archive.org/metadata/nes-romset-ultra-us"


def extract_zip(zip_file_path: str, extract_to_path: str):
    """
    Extracts a ZIP file to a specified directory.

    Parameters:
    - zip_file_path: str, the path to the ZIP file.
    - extract_to_path: str, the directory to extract the files into.
    """
    # Ensure the extraction path exists, if not create it
    if not os.path.exists(extract_to_path):
        os.makedirs(extract_to_path)

    try:
        with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
            zip_ref.extractall(extract_to_path)
            print(f"Extracted {zip_file_path} to {extract_to_path}")
    except zipfile.BadZipfile:
        print(
            f"An error occurred while extracting {zip_file_path} to {extract_to_path}")


def show_header_message():
    """
    Just show a fancy message to appear to be a cool programmer!
    """

    print("""
            _   _  _____ _____  ______                      _ 
        | \ | ||  ___/  ___| | ___ \                    | |
        |  \| || |__ \ `--.  | |_/ /____      _____ _ __| |
        | . ` ||  __| `--. \ |  __/ _ \ \ /\ / / _ \ '__| |
        | |\  || |___/\__/ / | | | (_) \ V  V /  __/ |  |_|
        \_| \_/\____/\____/  \_|  \___/ \_/\_/ \___|_|  (_)
    """)

    print("The main purpose of this script is to download the neccessary files to start to enjoy NES on the Mister FPGA")


def convert_size(size_bytes: int):
    if size_bytes == 0:
        return "0B"
    size_name = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")
    i = int(math.floor(math.log(size_bytes, 1024)))
    p = math.pow(1024, i)
    s = round(size_bytes / p, 2)
    return f"{s} {size_name[i]}"


def get_total_files_size_to_download(files: list):
    total_size = 0
    for file in files:
        # we will ensure that only zip files will be used to get the all the files size
        if file['format'] == 'ZIP':
            total_size += int(file['size'])

    return total_size


def process_downloads(json_url: str):
    """
    Process the downloads of the files
    """

    if not os.path.exists(DIRECTORY_DESTINATION):
        print(
            f"Destination directory {DIRECTORY_DESTINATION} does not exist. Please create it and try again.")
        return

    print(f"Reading remote JSON: {json_url}")

    json_file = requests.get(
        json_url)

    json_file_raw_data = json_file.json()

    created_at_datetime = datetime.fromtimestamp(
        int(json_file_raw_data['created']))

    print(f"The source was created at: {created_at_datetime}")
    print(
        f"Total files to download: {len(json_file_raw_data['files'])} about {convert_size(get_total_files_size_to_download(json_file_raw_data['files']))}")
    print("==========================================================================")

    server_url = json_file_raw_data['alternate_locations']['workable'][0]['server']
    server_path = json_file_raw_data['alternate_locations']['workable'][0]['dir']

    downloaded_files_count = 1

    for rom_file in json_file_raw_data['files']:

        download_url = f"https://{server_url}/{server_path}/{rom_file['name']}"

        response = requests.get(download_url)

        file_path = f"{DIRECTORY_DESTINATION}{rom_file['name']}"

        print(
            f"{downloaded_files_count}. Downloading: \"{rom_file['name']}\" {convert_size(float(rom_file['size']))} into {DIRECTORY_DESTINATION}")

        with open(file_path, 'wb') as downloaded_rom_file:
            downloaded_rom_file.write(response.content)

        print("Extracting file...")
        extract_zip(
            file_path, DIRECTORY_DESTINATION)
        os.remove(file_path)

        # Just download 5 files to test
        # if downloaded_files_count == 5:
        #     break
        downloaded_files_count += 1

    print("==========================================================================")
    print(f"Downloaded {downloaded_files_count} files. Enjoy!")


def main():
    show_header_message()

    process_downloads(JSON_URL)


if __name__ == "__main__":
    main()
