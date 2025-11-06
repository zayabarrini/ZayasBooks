#!/bin/bash

# Get the current directory where the script is running
CURRENT_DIR=$(pwd)

# Function to clean empty directories
clean_empty_dirs() {
    local base_dir="$1"
    if [ -d "$base_dir" ]; then
        find "$base_dir" -type d -empty -delete 2>/dev/null
    fi
}

# Function to check if file is an ebook
is_ebook() {
    local file="$1"
    local ebook_extensions="pdf epub mobi azw3 txt doc docx rtf djvu fb2 cbz cbr"
    local extension=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')
    
    for ext in $ebook_extensions; do
        if [ "$extension" = "$ext" ]; then
            return 0
        fi
    done
    return 1
}

# Function to organize by theme
organize_by_theme() {
    # Find all ebook files and organize by theme
    find . -maxdepth 2 -type f -not -path "*/\.*" | while read -r file; do
        filename=$(basename "$file")
        script_name=$(basename "$0")
        
        # Skip script file and non-ebook files
        if [[ "$filename" == "$script_name" ]] || ! is_ebook "$file"; then
            continue
        fi
        
        # Extract theme name (first part before first hyphen)
        theme=$(echo "$filename" | cut -d'-' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        # Skip if no theme found or theme is empty
        if [ -z "$theme" ] || [ "$theme" = "$filename" ]; then
            continue
        fi
        
        # Replace underscores with spaces for folder name
        folder_name=$(echo "$theme" | tr '_' ' ')
        
        # Create theme folder if it doesn't exist
        mkdir -p "$folder_name"
        
        # Move file to theme folder
        mv "$file" "$folder_name/" 2>/dev/null
    done
}

# Function to organize by language
organize_by_language() {
    # Find all ebook files and organize by language
    find . -maxdepth 2 -type f -not -path "*/\.*" | while read -r file; do
        filename=$(basename "$file")
        
        # Skip non-ebook files
        if ! is_ebook "$file"; then
            continue
        fi
        
        # Convert filename to lowercase for easier matching
        lower_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
        
        # Check for language patterns and move files
        case "$lower_filename" in
            *-ar*|*arabic*)
                mkdir -p "ar"
                mv "$file" "ar/" 2>/dev/null
                ;;
            *-el*|*greek*|*-gr*)
                mkdir -p "el"
                mv "$file" "el/" 2>/dev/null
                ;;
            *-pl*|*polish*|*-po*)
                mkdir -p "pl"
                mv "$file" "pl/" 2>/dev/null
                ;;
            *-he*|*hebrew*|*-hb*)
                mkdir -p "he"
                mv "$file" "he/" 2>/dev/null
                ;;
            *-tr*|*turkish*|*-tu*)
                mkdir -p "tr"
                mv "$file" "tr/" 2>/dev/null
                ;;
            *-ch*|*-zh*|*-cn*|*chinese*)
                mkdir -p "zh"
                mv "$file" "zh/" 2>/dev/null
                ;;
            *-de*|*german*)
                mkdir -p "de"
                mv "$file" "de/" 2>/dev/null
                ;;
            *-en*|*english*)
                mkdir -p "en"
                mv "$file" "en/" 2>/dev/null
                ;;
            *-es*|*spanish*)
                mkdir -p "es"
                mv "$file" "es/" 2>/dev/null
                ;;
            *-fr*|*french*)
                mkdir -p "fr"
                mv "$file" "fr/" 2>/dev/null
                ;;
            *-hi*|*hindi*)
                mkdir -p "hi"
                mv "$file" "hi/" 2>/dev/null
                ;;
            *-it*|*italian*)
                mkdir -p "it"
                mv "$file" "it/" 2>/dev/null
                ;;
            *-ja*|*-jp*|*japanese*)
                mkdir -p "ja"
                mv "$file" "ja/" 2>/dev/null
                ;;
            *-ko*|*korean*)
                mkdir -p "ko"
                mv "$file" "ko/" 2>/dev/null
                ;;
            *-ru*|*russian*)
                mkdir -p "ru"
                mv "$file" "ru/" 2>/dev/null
                ;;
            *-pt*|*portuguese*)
                mkdir -p "pt"
                mv "$file" "pt/" 2>/dev/null
                ;;
            *-la*|*latin*)
                mkdir -p "la"
                mv "$file" "la/" 2>/dev/null
                ;;
            *-ml*|*malayalam*)
                mkdir -p "ml"
                mv "$file" "ml/" 2>/dev/null
                ;;
            *-id*|*indonesian*)
                mkdir -p "id"
                mv "$file" "id/" 2>/dev/null
                ;;
            *-sw*|*swahili*)
                mkdir -p "sw"
                mv "$file" "sw/" 2>/dev/null
                ;;
        esac
    done
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

# Final cleanup of any empty directories that might have been created
find . -maxdepth 1 -type d -empty -not -name ".*" -delete 2>/dev/null

echo "Organization complete!"