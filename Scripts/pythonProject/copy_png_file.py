import os
import shutil
import tkinter
from tkinter import filedialog


def copy_png_file(source_directory, target_directory):
    for root, dirs, files in os.walk(source_directory):
        for dir_name in dirs:
            data_segment_dir = os.path.join(root, dir_name, 'DataWithoutROI')
            data_roi_dir = os.path.join(root, dir_name, 'DataROI')
            if os.path.isdir(data_segment_dir):
                if root.split('\\')[1] in ['Ductopenia', 'Normal']:
                    for file_name in os.listdir(data_segment_dir):
                        if '0_90_0' in file_name.lower():
                            source_file_path = os.path.join(data_segment_dir, file_name)
                            target_file_path = os.path.join(target_directory, os.path.basename(root))
                            os.makedirs(target_file_path, exist_ok=True)
                            shutil.copy2(source_file_path, target_file_path)
            if os.path.isdir(data_roi_dir):
                if root.split('\\')[1] in ['Ductopenia', 'Normal']:
                    for file_name in os.listdir(data_roi_dir):
                        if '0_90_0' in file_name.lower():
                            source_file_path = os.path.join(data_roi_dir, file_name)
                            target_file_path = os.path.join(target_directory, os.path.basename(root))
                            os.makedirs(target_file_path, exist_ok=True)
                            shutil.copy2(source_file_path, target_file_path)


tkinter.Tk().withdraw()  # prevents an empty tkinter window from appearing
main_directory = filedialog.askdirectory(initialdir="C:/Projects/Thesis/salivary/Out")

# Specify the source directory containing the directory structure
source_directory = main_directory + "/Data"

# Specify the target directory to save the copied images
target_directory = main_directory + "/Notes"

copy_png_file(source_directory, target_directory)
