#!/bin/bash

SP_YEAR=1999
START_INDEX=1
LAST_CLOSE=1464.47 # THIS IS THE TRADING DAY BEFORE THE LAST TRADING DAY OF 1999.
F_OPEN_DIFF_THAN_CLOSE="FALSE"

while [[ $SP_YEAR -le 2025 ]]; do
	# echo "sp500-${SP_YEAR}.csv"

	CSVFILE="spx-${SP_YEAR}.csv"
	FIRST_LINE=$(head -n 1 "${CSVFILE}")

	NUM_LINES=$(cat "${CSVFILE}" | wc -l)
	CTR=$NUM_LINES
	# echo "${FIRST_LINE}"
	while [[ $CTR -gt 1 ]]; do

		LINE=$(cat "${CSVFILE}" | head -n $CTR | tail -n 1)
		DATE=$(echo "${LINE}" | cut -f1 -d,)
		# STATS=$(echo "${LINE}" | cut -f2- -d,)
		OPEN=$(echo "${LINE}" | cut -f2 -d'"' | tr -d , )
		HIGH=$(echo "${LINE}" | cut -f4 -d'"' | tr -d , )
		LOW=$(echo "${LINE}" | cut -f6 -d'"' | tr -d , )
		CLOSE=$(echo "${LINE}" | cut -f8 -d'"' | tr -d , )
	
		YEAR=$(echo "${DATE}" | cut -f3 -d/)
		DAY=$(echo "${DATE}" | cut -f2 -d/)
		MONTH=$(echo "${DATE}" | cut -f1 -d/)

		if [[ "${OPEN}" != "${CLOSE}" ]]; then
			F_OPEN_DIFF_THAN_CLOSE="TRUE"
		fi

		if [[ "${F_OPEN_DIFF_THAN_CLOSE}" == "FALSE" ]]; then
			echo "${START_INDEX},${YEAR}-${MONTH}-${DAY},SPX,${LAST_CLOSE},${HIGH},${LOW},${CLOSE}" | tr -d '"'
			LAST_CLOSE=${CLOSE}
		else
			echo "${START_INDEX},${YEAR}-${MONTH}-${DAY},SPX,${OPEN},${HIGH},${LOW},${CLOSE}" | tr -d '"'
		fi

		((CTR--))
		((START_INDEX++))
	done

	((SP_YEAR++))
done

