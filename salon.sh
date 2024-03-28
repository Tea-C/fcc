#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo "Welcome to my Salon, how can I help you?"
  fi
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) exit"
  read SERVICE_ID_SELECTED

  if [[ $SERVICE_ID_SELECTED > 0 && $SERVICE_ID_SELECTED < 6 ]]
  then
    SELECTION_MENU
  else
    if [[ $SERVICE_ID_SELECTED == 6 ]]
    then
      EXIT
    else
      MAIN_MENU "I could not find that service. What would you like today?"
    fi
  fi

}
SELECTION_MENU() {
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
#get customer name
PHONE_NUMBER_RESULT=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
#if not found
if [[ -z $PHONE_NUMBER_RESULT ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
#insert new customer
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
#get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your $(echo $SERVICE | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
  read SERVICE_TIME
 #insert appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)") 
  echo -e "\nI have put you down for a $(echo $SERVICE | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}

EXIT() {
  echo Exit
}

MAIN_MENU
