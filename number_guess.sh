#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

START() {

#generate random number
  NUMBER=$((1+$RANDOM%1000))
  UPDATE_NUMBER=$($PSQL "UPDATE number SET secret_number=$NUMBER")
  echo $NUMBER
#ask for username
echo -e "\nEnter your username:"
read NAME
if [[ $NAME ]]
  then
  #select username in db
  USER=$($PSQL "SELECT username FROM player WHERE username = '$NAME'")
  if [[ ! -z $USER ]]
    then 
    #echo username game stats
    PLAYED=$($PSQL "SELECT games_played FROM player WHERE username = '$NAME'")
    BEST=$($PSQL "SELECT best_game FROM player WHERE username = '$NAME'")
    echo -e "\nWelcome back, $USER! You have played $PLAYED games, and your best game took $BEST guesses. "
  else
    #if not username
    #insert row
    #echo username welcome
    INSERT_USER=$($PSQL "INSERT INTO player(username) VALUES('$NAME')")
    echo -e "\nWelcome, $NAME! It looks like this is your first time here."
  fi
  I=0
  GUESSING() {
    if [[ $1 ]]
  then
    echo -e "\n$1"
    else
  #ask for guess
  echo -e "\nGuess the secret number between 1 and 1000:"
  fi
  read GUESS
    #check if integer
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
      then
        GUESSING "That is not an integer, guess again:"
      else
      ((I++))
      #check if guess is number, above or below
      if [[ $GUESS == $NUMBER ]]
        then 
        #update game stats
          ((PLAYED++))
          UPDATE_PLAYED=$($PSQL "UPDATE player SET games_played=$PLAYED WHERE username = '$NAME'")
          # check if best game
          BEST=$($PSQL "SELECT best_game FROM player WHERE username = '$NAME'")
        if [[ $I < $BEST || $BEST == 0 ]]
          then
          UPDATE_BEST=$($PSQL "UPDATE player SET best_game=$I WHERE username = '$NAME'")
        fi
        #echo lower, higher or number of tries
        SECRET=$($PSQL "SELECT secret_number FROM number")
        echo -e "\nYou guessed it in $I tries. The secret number was $SECRET. Nice job!"
        else
          if (( $GUESS < $NUMBER ))
            then
            GUESSING "It's higher than that, guess again:"
            else
              GUESSING "It's lower than that, guess again:"
          fi
      fi
    fi
 }
 GUESSING
fi
}

START
