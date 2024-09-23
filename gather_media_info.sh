#!/bin/sh

# Generate a timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")

# Output CSV file with timestamp
OUTPUT_FILE="$OUTPUT_DIR/media_info_$timestamp.csv"

# Write CSV header
echo "Movie Name,File Name,Format,Codec,Duration,Bit Rate" > $OUTPUT_FILE

# Count total number of movie directories
total_movies=$(find "$MOVIE_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
current_movie=0

# Loop through each movie folder
for movie_dir in "$MOVIE_DIR"/*; do
    if [ -d "$movie_dir" ]; then
        current_movie=$((current_movie + 1))
        movie_name=$(basename "$movie_dir")
        
        echo "Processing movie $current_movie of $total_movies: $movie_name"
        
        # Loop through each file in the movie directory
        for media_file in "$movie_dir"/*; do
            if [ -f "$media_file" ]; then
                file_extension="${media_file##*.}"
                
                # Check if the file is a video file (e.g., mp4, mkv, avi)
                case "$file_extension" in
                    mp4|mkv|avi|mov|wmv|flv|webm)
                        file_name=$(basename "$media_file")
                        format=$(mediainfo --Inform="General;%Format%" "$media_file")
                        codec=$(mediainfo --Inform="Video;%CodecID%" "$media_file")
                        duration=$(mediainfo --Inform="General;%Duration/String3%" "$media_file")
                        bit_rate=$(mediainfo --Inform="General;%OverallBitRate/String%" "$media_file")

                        # Append information to CSV
                        echo "$movie_name,$file_name,$format,$codec,$duration,$bit_rate" >> $OUTPUT_FILE
                        ;;
                    *)
                        echo "Skipping non-video file: $media_file"
                        ;;
                esac
            fi
        done
    fi
done

echo "Media information has been gathered in $OUTPUT_FILE"

