#!/bin/bash 
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

QUESTION="Please provide an element as an argument."

MAIN_FUNCTION() {
  if [[ -z $1 ]]
  then 
    # if empty argument
    echo $QUESTION
  else 
    # if already given
    PRINT_FUNCTION $1
  fi  
}

PRINT_FUNCTION(){
  INPUT=$1
  
  # if not a number
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    COLUMN=$($PSQL"SELECT atomic_number, name, symbol, atomic_mass, type, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_ID) WHERE name='$INPUT' OR symbol='$INPUT'; ")
  else
    COLUMN=$($PSQL"SELECT atomic_number, name, symbol, atomic_mass, type, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_ID) WHERE atomic_number=$INPUT; ")
  fi
                                                                                                                                                                                                            #WHERE name='$INPUT' OR symbol='$INPUT' OR atomic_number=$INPUT;
    # if output not listed
  if [[ -z $COLUMN ]]
  then
    echo "I could not find that element in the database."
  else 
    # decompose the variables
    while IFS='|' read -r atomic_number name symbol atomic_mass type melting_point boiling_point; do
    # Assign each field to a variable
    atomic_number_var=$(echo "$atomic_number" | awk '{$1=$1; print}')
    name_var=$(echo "$name"| awk '{$1=$1; print}')
    symbol_var=$(echo "$symbol"| awk '{$1=$1; print}')
    atomic_mass_var=$(echo "$atomic_mass"| awk '{$1=$1; print}')
    type_var=$(echo "$type"| awk '{$1=$1; print}')
    melting_point_var=$(echo "$melting_point"| awk '{$1=$1; print}')
    boiling_point_var=$(echo "$boiling_point"| awk '{$1=$1; print}')
    done <<< "$COLUMN"

    # print final statement
    echo "The element with atomic number $atomic_number_var is $name_var ($symbol_var). It's a $type_var, with a mass of $atomic_mass_var amu. $name_var has a melting point of $melting_point_var celsius and a boiling point of $boiling_point_var celsius."
  fi      
  
}

# Execute MAIN_FUNCTION
MAIN_FUNCTION $1

