#! /bin/bash
mutagen-compose -f docker-compose.yml -f docker-compose.mutagen.yml $1 $2 $3
