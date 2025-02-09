import tkinter as tk
from tkinter import filedialog
from data_splitter import DataSplitter

# Prevents an empty Tkinter window from appearing
tk.Tk().withdraw()

# Select the source folder using a file dialog
folder_path = filedialog.askdirectory(initialdir="F:/Elia/salivary/Out")

# Define the data parameters
folder_data_name = "DataSegment"
groups = ["Basic", "Moderate", "Severe"]
data_splits = ["Train", "Test"]

# Create an instance of DataSplitter with the provided parameters
splitter = DataSplitter(folder_path, folder_data_name, groups, data_splits)

# Execute the data splitting process
splitter.process_data()
