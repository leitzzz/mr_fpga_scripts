#!/usr/bin/python3

import requests  # pylint: disable=import-error

DIRECTORY_DESTINATION = "/media/fat/games/PSX/"
# DIRECTORY_DESTINATION = "./"

BIOS_URLS = {'us': "https://archive.org/download/rr-sony-playstation-u/bios/scph7001.7z/scph7001.bin",
             'jp': "https://archive.org/download/rr-sony-playstation-u/bios/scph7000.7z/scph7000.bin", 'eu': "https://archive.org/download/rr-sony-playstation-u/bios/scph7502.7z/scph7502.bin"}

# DEMO FILE TO PLAY AND TEST THE BIOS....
DEMO_FILE_URL = "https://archive.org/download/chd_psx_eur/CHD-PSX-EUR/Super%20Dropzone%20-%20Intergalactic%20Rescue%20Mission%20%28Europe%29.chd"
DEMO_FILE_NAME = "Super Dropzone - Intergalactic Rescue Mission (Europe).chd"


def show_header_message():
    """
    Just show a fancy message to appear to be a cool programmer!
    """

    print("""
        ______  _______   __ ______
        | ___ \/  ___\ \ / / | ___ \
        | |_/ /\ `--. \ V /  | |_/ /____      _____ _ __
        |  __/  `--. \/   \  |  __/ _ \ \ /\ / / _ \ '__|
        | |    /\__/ / /^\ \ | | | (_) \ V  V /  __/ |
        \_|    \____/\/   \/ \_|  \___/ \_/\_/ \___|_|
    """)

    print("The main purpose of this script is to download the neccessary files to start to enjoy PSX on the Mister FPGA")


def download_file(file_url: str, file_name: str, verbose: bool = False):
    """
    Download a file from a URL and save it to a specified path.

    Parameters:
    - file_url: str, the URL to download the file from.
    - file_name: str, the name of the file to save.
    """
    if verbose:
        print(f"Downloading {file_url} to {file_name}...")

    response = requests.get(file_url)

    with open(file_name, 'wb') as downloaded_file:
        downloaded_file.write(response.content)


def process_downloads(bios_urls: dict):
    """
    Download the necessary files to start to enjoy PSX on the Mister FPGA.
    """

    for region, url in bios_urls.items():
        if region == 'us':
            file_name = f"{DIRECTORY_DESTINATION}boot.rom"
        if region == 'jp':
            file_name = f"{DIRECTORY_DESTINATION}boot1.rom"
        if region == 'eu':
            file_name = f"{DIRECTORY_DESTINATION}boot2.rom"

        download_file(url, file_name, verbose=True)


def main():
    show_header_message()

    print("I will only download the BIOS files for the PSX. And one demo game to test the BIOS.")

    process_downloads(BIOS_URLS)

    # demo game file
    download_file(
        DEMO_FILE_URL, f"{DIRECTORY_DESTINATION}{DEMO_FILE_NAME}", True)

    print("All files downloaded successfully! Now find some games by yourself and put them in the \"games/PSX/\" folder.")


if __name__ == "__main__":
    main()
