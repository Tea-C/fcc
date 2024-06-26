#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#DELETE 
echo "$($PSQL "TRUNCATE teams CASCADE")"

#get data from file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != 'winner' ]]
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RES="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $INSERT_WINNER_RES == 'INSERT 0 1' ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        echo Inserted: $WINNER $WINNER_ID
      fi
    fi
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RES="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_OPPONENT_RES == 'INSERT 0 1' ]]
      then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        echo Inserted: $OPPONENT $OPPONENT_ID
      fi
    fi
fi
if [[ $WINNER != 'winner' ]]
then
 #insert into games
  INSERT_GAMES_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, opponent_goals, winner_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $OPPONENT_GOALS, $WINNER_GOALS)")"
  if [[ $INSERT_GAMES_RESULT='INSERT 0 1' ]]
  then
    echo Inserted $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $OPPONENT_GOALS, $WINNER_GOALS
  fi
fi
done
