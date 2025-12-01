#!/bin/sh

Y=2025
C=  # Insert session cookie here
A="nikola.benes@gmail.com via curl"

if [ "$C" = "" ]; then
	echo "Missing session cookie."
	exit
fi

DAY="$1"

if [ "$DAY" = "" ]; then
	echo "Usage: $0 <day_number>"
	exit
fi

ZDAY=$(printf '%02d' "$1")

curl "https://adventofcode.com/$Y/day/$DAY/input" \
	--cookie "session=$C" --user-agent "$A" > "input$ZDAY"
