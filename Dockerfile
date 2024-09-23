FROM alpine:latest
RUN apk add --no-cache mediainfo

WORKDIR /app
COPY gather_media_info.sh .

RUN chmod +x gather_media_info.sh

ENV MOVIE_DIR=/movies
ENV OUTPUT_DIR=/output

# Define the entrypoint
ENTRYPOINT ["./gather_media_info.sh"]
