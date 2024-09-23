#!/bin/sh

# Generate a timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")

# Output CSV file with timestamp
OUTPUT_FILE="$OUTPUT_DIR/media_info_$timestamp.csv"

# Write CSV header
echo "Movie Name,File Name,Format,Codec,Duration,Bit Rate" > $OUTPUT_FILE

# Loop through each movie folder
for movie_dir in "$MOVIE_DIR"/*; do
    if [ -d "$movie_dir" ]; then
        movie_name=$(basename "$movie_dir")
        
        # Loop through each file in the movie directory
        for media_file in "$movie_dir"/*; do
            if [ -f "$media_file" ]; then
                file_name=$(basename "$media_file")
                format=$(mediainfo --Inform="General;%Format%" "$media_file")
                codec=$(mediainfo --Inform="Video;%CodecID%" "$media_file")
                duration=$(mediainfo --Inform="General;%Duration/String3%" "$media_file")
                bit_rate=$(mediainfo --Inform="General;%OverallBitRate/String%" "$media_file")

                # Append information to CSV
                echo "$movie_name,$file_name,$format,$codec,$duration,$bit_rate" >> $OUTPUT_FILE
            fi
        done
    fi
done

echo "Media information has been gathered in $OUTPUT_FILE"

