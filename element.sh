#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [ -z "$1" ]; then
    echo "Please provide an element as an argument."
    exit 0
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
    QUERY_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = '$1';")
else
    QUERY_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1';")
fi

if [ -z "$QUERY_RESULT" ]; then
    echo "I could not find that element in the database."
else
    echo "$QUERY_RESULT" | while IFS='|' read atomic_number name symbol type atomic_mass melting_point boiling_point; do
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    done
fi