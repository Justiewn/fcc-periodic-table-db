#!/bin/bash
# Enter an element by Atomic number, Symbol, or Name to get more information about it.

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_SEARCH=$( $PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e
                                    LEFT JOIN properties AS p ON e.atomic_number = p.atomic_number
                                    LEFT JOIN types AS t ON p.type_id = t.type_id
                                    WHERE e.atomic_number = $1")

  else
    ELEMENT_SEARCH=$( $PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e
                                  LEFT JOIN properties AS p ON e.atomic_number = p.atomic_number
                                  LEFT JOIN types AS t ON p.type_id = t.type_id
                                  WHERE e.symbol = '$1'")

    if [[ -z $ELEMENT_SEARCH ]]
    then  
        ELEMENT_SEARCH=$( $PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e
                                    LEFT JOIN properties AS p ON e.atomic_number = p.atomic_number
                                    LEFT JOIN types AS t ON p.type_id = t.type_id
                                    WHERE e.name = '$1'")
    fi
  fi
  
  if [[ -z $ELEMENT_SEARCH ]]
  then
    echo I could not find that element in the database.
  else
    IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING BOILING <<< "$ELEMENT_SEARCH"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi