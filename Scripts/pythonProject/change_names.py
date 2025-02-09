import os


def clean_invisible_chars(text):
    """
    Removes invisible Unicode characters like RLM, LRM from a string.
    """
    invisible_chars = ["\u200e", "\u200f"]  # LRM and RLM
    for char in invisible_chars:
        text = text.replace(char, "")
    return text


def rename_folders_with_hidden_chars(root_folder):
    """
    Renames folders in the root folder by removing invisible characters from their names.

    :param root_folder: The root directory containing folders to rename.
    """
    for folder_name in os.listdir(root_folder):
        original_path = os.path.join(root_folder, folder_name)

        # Skip if it's not a directory
        if not os.path.isdir(original_path):
            continue

        # Clean the folder name
        cleaned_name = clean_invisible_chars(folder_name)

        # If the name is different, rename the folder
        if folder_name != cleaned_name:
            new_path = os.path.join(root_folder, cleaned_name)

            # Check if a folder with the cleaned name already exists
            if os.path.exists(new_path):
                print(f"Skipping: {original_path} (cleaned name already exists: {new_path})")
                continue

            # Rename the folder
            os.rename(original_path, new_path)
            print(f"Renamed: {original_path} -> {new_path}")


# Example usage
root_directory = "C:\\elia\\Detecting_Ductopenic_Parotid_Salivary_Glands\\Out\\DataThreeGroups\\Data\\Severe"  # Replace with your actual directory path
rename_folders_with_hidden_chars(root_directory)