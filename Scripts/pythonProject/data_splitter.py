import os
import shutil
import pandas as pd


class DataSplitter:
    """
    Class responsible for managing data splitting into different dataset partitions.
    """

    # Define constants for folder names
    DEEP_LEARNING_DIR = "DeepLearning"
    DATA_DIR = "Data"

    def __init__(self, folder_path, folder_data_name, groups, data_splits):
        """
        Initializes the DataSplitter instance.

        :param folder_path: The root directory where the data is located.
        :param folder_data_name: The name of the subfolder containing the data to be processed.
        :param groups: A list of data groups (e.g., "Basic", "Moderate", "Severe").
        :param data_splits: A list of dataset splits (e.g., "Train", "Test", "Validation").
        """
        self.folder_path = folder_path
        self.folder_data_name = folder_data_name
        self.groups = groups
        self.data_splits = data_splits

        # Define destination folder paths dynamically using the constants
        self.destination_paths = {
            split: os.path.join(self.folder_path, self.DEEP_LEARNING_DIR, self.folder_data_name, split)
            for split in self.data_splits
        }

        # Create destination directories if they don't exist
        for path in self.destination_paths.values():
            os.makedirs(path, exist_ok=True)

    def process_data(self):
        """
        Processes the data by retrieving lists of files and copying them to the appropriate directories.
        """
        for group in self.groups:
            for split in self.data_splits:
                file_list = self.get_list(self.folder_path, group, split)  # Dynamically get file list for each split
                self.copy_group(group, self.destination_paths[split], file_list)  # Copy files dynamically

        return {"status": "success", "message": "Data splitting completed"}

    def copy_group(self, group, destination_split, list_split):
        """
        Copies a group of files from the source directory to the destination directory.

        :param group: The name of the data group.
        :param destination_split: The destination folder for the split (Train/Test/Validation).
        :param list_split: A list of filenames that belong to the specified split.
        """
        group_path = os.path.join(self.folder_path, self.DATA_DIR, group)  # Use constant for "Data" directory
        destination = os.path.join(destination_split, group)
        os.makedirs(destination, exist_ok=True)

        print(f"Copying group: {group} to {destination}")
        self.copy_files(group, list_split, group_path, destination)
        print(f"Finished copying group: {group}")

    def copy_files(self, group, list_split, group_path, destination_group_path):
        """
        Copies files from the source directory to the target directory based on the provided list.

        :param group: The name of the data group.
        :param list_split: A list of filenames to copy.
        :param group_path: The source folder where the group data is stored.
        :param destination_group_path: The target folder where the files should be copied.
        """
        copied_files = 0
        for case in list_split:
            case_path = os.path.join(group_path, case, self.folder_data_name)
            if os.path.isdir(case_path):
                for file in os.listdir(case_path):
                    shutil.copy(os.path.join(case_path, file), destination_group_path)
                    copied_files += 1
            else:
                print(f"Skipping {case} (folder not found)")
        print(f"Finished copying {copied_files} files for group: {group}")

    def get_list(self, folder_path, group, split):
        folder_path = folder_path + "/DeepLearning/TrainTest.xlsx"
        conditions = {
                "Classification": group,
                "Valid": "V",
                "Split": split
            }
        return self.filter_data_by_conditions(folder_path, conditions)

    def filter_data_by_conditions(self, file_path, conditions):
        # Load the Excel file
        df = pd.read_excel(file_path, sheet_name="Data")

        # Create a boolean mask for the conditions
        condition_mask = None
        for condition_column, condition_value in conditions.items():
            if condition_mask is None:
                condition_mask = df[condition_column] == condition_value
            else:
                condition_mask &= df[condition_column] == condition_value

        # Filter the data based on the conditions
        filtered_data = df[condition_mask]["Name"].tolist()

        return filtered_data


