#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    #Save the argument in a variable
    ARGUMENT=$1

    #Check if the argument is a number

    if [[ $ARGUMENT =~ ^[0-9]+$ ]]
      then
        ELEMENT_REQUESTED_RESULT=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ARGUMENT;")

        if [[ -z $ELEMENT_REQUESTED_RESULT ]]
          then
            echo There is no element with that atomic number
          else
            echo "$ELEMENT_REQUESTED_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE_NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
              do
                echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
              done
        fi

        else
        #Try to find the element requested
        ELEMENT_REQUESTED_RESULT=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$ARGUMENT' OR name = '$ARGUMENT';")

        if [[ -z $ELEMENT_REQUESTED_RESULT ]]
          then
            echo "I could not find that element in the database."
          else
            echo "$ELEMENT_REQUESTED_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE_NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
              do
                echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
              done
        fi

    fi

fi