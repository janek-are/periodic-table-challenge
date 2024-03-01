#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# jeśli nie ma argumentu
if [[ -z $1 ]] 
then
echo -e "Please provide an element as an argument."
exit
fi

#jeśli argument jest liczbą
if [[ $1 =~ ^[0-9]+$ ]] 
then 
PIERWIASTEK=$($PSQL "SELECT atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE atomic_number = $1")
else 
#jeśli nie, to jest albo symbolem albo 
PIERWIASTEK=$($PSQL "SELECT atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE name = '$1' OR symbol = '$1'")
fi

#jeśli nie ma takiego pierwiastka, to wywal błąd
if [[ -z $PIERWIASTEK ]] 
then
echo -e "I could not find that element in the database."
exit
fi 

#wyświetl wiadomość końcową 
echo $PIERWIASTEK | while IFS=" |" read AT_NUM TYPE MASS MELT BOIL SYMBOL NAME
do
echo -e "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done
