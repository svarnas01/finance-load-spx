#!/bin/bash

COMBINE_SCRIPT=./combine-fix-spx-files.sh
CSV_FILE=spx-allyears.csv
TABLE=stock_date


if [[ ! -e "${COMBINE_SCRIPT}" ]]; then
	echo -e "\nCSV file \"${COMBINE_SCRIPT}\" missing.\n"
	exit 255
fi

echo "Note: this script can take over a minute to run."
echo ""

echo "Combining/fixing raw data files..."
${COMBINE_SCRIPT} > "${CSV_FILE}"

if [[ ! -e "${CSV_FILE}" ]]; then
	echo -e "\nCSV file \"${CSV_FILE}\" missing.\n"
	exit 255
fi

echo "Creating & populating the database..."

pg-cmd.sh "DROP TABLE IF EXISTS ${TABLE}" > /dev/null 2>&1

pg-cmd.sh "CREATE TABLE ${TABLE} (
	sd_id       SERIAL,
	mkt_date    DATE NOT NULL,
 	symbol      VARCHAR(8) NOT NULL,
 	open_price  NUMERIC(17,3) NOT NULL,
 	high_price  NUMERIC(17,3) NOT NULL,
 	low_price   NUMERIC(17,3) NOT NULL,
 	close_price NUMERIC(17,3) NOT NULL
)"


pg-cmd.sh "COPY ${TABLE}
	FROM '$PWD/${CSV_FILE}'
	DELIMITER ','
"

pg-cmd.sh "SELECT COUNT(*) FROM ${TABLE}"
