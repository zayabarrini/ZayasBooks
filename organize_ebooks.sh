#!/bin/bash

# adb push organize_ebooks.sh /sdcard/Books/
# adb shell
# cd /sdcard/Books/
# sh organize_ebooks.sh
# adb shell bash /sdcard/Books/organize_ebooks.sh

# Get the current directory where the script is running
CURRENT_DIR=$(pwd)

# Function to clean empty directories
clean_empty_dirs() {
    local base_dir="$1"
    if [ -d "$base_dir" ]; then
        find "$base_dir" -type d -empty -delete 2>/dev/null
    fi
}

# Function to organize by theme
organize_by_theme() {
    # Get the script's own filename to exclude it from processing
    script_name=$(basename "$0")
    
    # Create Theme directory if it doesn't exist
    mkdir -p "Theme"
    
    # Find all files with the theme-filename-language pattern
    find . -type f | while read -r file; do
        if [[ "$(basename "$file")" == "$script_name" ]]; then
            continue
        fi
        # Extract theme name (first part before first hyphen)
        theme=$(basename "$file" | cut -d'-' -f1)
        # Replace underscores with spaces for folder name
        folder_name=$(echo "$theme" | tr '_' ' ')
        
        # Create theme folder if it doesn't exist
        mkdir -p "Theme/$folder_name"
        
        # Move file to theme folder
        mv "$file" "Theme/$folder_name/"
    done 2>/dev/null

    # Clean empty Language directories if they exist
    clean_empty_dirs "Language"
    
    echo "Files have been organized by theme in the 'Theme' directory."
}

# Function to organize by language
organize_by_language() {
    # Create Language directory if it doesn't exist
    mkdir -p "Language"
    
    # Create language directories
    for lang in ar ch de en es fr gr hb hi it ja ko po ru la pt ml id sw tu jp zh cn trans; do
        mkdir -p "Language/$lang"
    done

    # Move files based on language patterns using individual find commands
    find . -type f -name "*-ar*" -exec mv {} "Language/ar/" \; 2>/dev/null
    find . -type f -name "*-ch*" -exec mv {} "Language/ch/" \; 2>/dev/null
    find . -type f -name "*-zh*" -exec mv {} "Language/zh/" \; 2>/dev/null
    find . -type f -name "*-cn*" -exec mv {} "Language/cn/" \; 2>/dev/null
    find . -type f -name "*-de*" -exec mv {} "Language/de/" \; 2>/dev/null
    find . -type f -name "*-en*" -exec mv {} "Language/en/" \; 2>/dev/null
    find . -type f -name "*-es*" -exec mv {} "Language/es/" \; 2>/dev/null
    find . -type f -name "*-fr*" -exec mv {} "Language/fr/" \; 2>/dev/null
    find . -type f -name "*-gr*" -exec mv {} "Language/gr/" \; 2>/dev/null
    find . -type f -name "*-hb*" -exec mv {} "Language/hb/" \; 2>/dev/null
    find . -type f -name "*-hi*" -exec mv {} "Language/hi/" \; 2>/dev/null
    find . -type f -name "*-it*" -exec mv {} "Language/it/" \; 2>/dev/null
    find . -type f -name "*-ja*" -exec mv {} "Language/ja/" \; 2>/dev/null
    find . -type f -name "*-jp*" -exec mv {} "Language/jp/" \; 2>/dev/null
    find . -type f -name "*-ko*" -exec mv {} "Language/ko/" \; 2>/dev/null
    find . -type f -name "*-po*" -exec mv {} "Language/po/" \; 2>/dev/null
    find . -type f -name "*-ru*" -exec mv {} "Language/ru/" \; 2>/dev/null
    find . -type f -name "*-pt*" -exec mv {} "Language/pt/" \; 2>/dev/null
    find . -type f -name "*-la*" -exec mv {} "Language/la/" \; 2>/dev/null
    find . -type f -name "*-ml*" -exec mv {} "Language/ml/" \; 2>/dev/null
    find . -type f -name "*-id*" -exec mv {} "Language/id/" \; 2>/dev/null
    find . -type f -name "*-sw*" -exec mv {} "Language/sw/" \; 2>/dev/null
    find . -type f -name "*-tu*" -exec mv {} "Language/tu/" \; 2>/dev/null

    # Clean empty Theme directories if they exist
    clean_empty_dirs "Theme"
    
    echo "Files have been organized by language in the 'Language' directory."
}

# Main menu
echo "Ebook Organizer Script"
echo "Current directory: $CURRENT_DIR"
echo ""
echo "How would you like to organize your ebooks?"
echo "1. By Theme (groups files by their prefix before the first hyphen)"
echo "2. By Language (groups files by language codes in filenames)"
echo "3. Exit"
printf "Enter your choice (1, 2, or 3): "
read choice

case $choice in
    1)
        organize_by_theme
        ;;
    2)
        organize_by_language
        ;;
    3)
        echo "Exiting without changes."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again and select 1, 2, or 3."
        exit 1
        ;;
esac

# Final cleanup of any empty directories
clean_empty_dirs "Theme"
clean_empty_dirs "Language"

echo "Organization complete!"
echo "Files are organized in: $CURRENT_DIR"