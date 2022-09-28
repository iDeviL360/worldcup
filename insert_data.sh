#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams, games")

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $YEAR != year && $ROUND != round && $WINNER != winner && $OPPONENT != opponent && $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals ]]
  then
    
    # WINNER
    WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'")

    if [[ -z $WINNER_TEAM_ID ]]
    then
      
      INSERTED_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) values('$WINNER')")

      if [[ $INSERTED_WINNER_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into Teams: $WINNER
      fi
      
      WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'")
    fi
    

    #OPPONENT
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'")

    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      
      INSERTED_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")

      if [[ $INSERTED_OPPONENT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into Teams: $OPPONENT
      fi
      
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'")

    fi

    INSERTED_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    
    echo Inserted game: $YEAR $ROUND $WINNER_TEAM_ID $OPPONENT_TEAM_ID $WINNER_GOALS $OPPONENT_GOALS
  
  fi

done