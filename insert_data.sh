#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # column name and its row is not "winner" value
  if [[ $WINNER != "winner" ]]
  then
    WINNER_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    
    # if it's empty, insert the value
    if [[ -z $WINNER_TEAM_NAME ]]
    then
      INSERT_WINNER_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      #a row with the value was inserted...
      if [[ $INSERT_WINNER_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo A team is inserted, $WINNER
      fi
    fi
  fi


  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    
    if [[ -z $OPPONENT_TEAM_NAME ]]
    then
      INSERT_OPPONENT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPONENT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo A team is inserted, $OPPONENT
      fi
    fi
  fi


  if [[ $YEAR != "year" ]]
  then
    
    #winner_id and opponent_id:
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #insert game values (round must be inside '' because type is VARCHAR):
    INSERT_GAME_VALUES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

    if [[ $INSERT_GAME_VALUES == "INSERT 0 1" ]]
    then
      echo A game values row is inserted, $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done
