#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  echo $($PSQL "TRUNCATE teams,games")
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS;
do

  if [[ $YEAR != year ]]
  then
    # get team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert team_id
      INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')");
      if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
      then
        echo "Inserted Winner into Teams table, $WINNER"
      fi

    fi

    # get team_id - opp
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");

    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert team_id
      INSERT_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')");
      if [[ $INSERT_OPPONENT_ID == "INSERT 0 1" ]]
      then
        echo "Inserted Opponent into Teams table, $OPPONENT"
      fi

    fi

    #insert into games table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)");
    
  fi


done
