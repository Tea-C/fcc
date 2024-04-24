#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ $1 ]]
then
 if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1' OR name = '$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1' OR name = '$1'")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC")
    MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$1' OR name = '$1'")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$1' OR name = '$1'")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$1' OR name = '$1'")
    SYMBOL_FORM=$(echo $SYMBOL | sed 's/ |/"/')
      else 
        ATOMIC=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
        TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC")
        MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number = $1")
        MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number = $1")
        BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number = $1")
        SYMBOL_FORM=$(echo $SYMBOL | sed 's/ |/"/')
        fi
    if [[ ! -z $ATOMIC ]]
      then echo The element with atomic number $ATOMIC is $NAME \($SYMBOL_FORM\). It\'s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
    else
            echo I could not find that element in the database.
    fi
  else 
echo Please provide an element as an argument.
  fi

