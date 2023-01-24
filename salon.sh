#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  
  echo -e "\n +++ welcome to 'barts getto barba' salon +++"
  echo -e "\n please choose a service:\n\n 1) cut\n 2) brush\n 3) wash\n 4) exit"
  
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) AFTER_MAIN ;;
    2) AFTER_MAIN ;;
    3) AFTER_MAIN ;;
    4) EXIT ;;
    *) MAIN_MENU "enter a valid option" ;;
  esac
}

GET_PERSONAL_DATA() {
  echo -e "\nwhatz ya phone numba?"
  read CUSTOMER_PHONE
  CUSTOMER_PHONE_CHECK=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_PHONE_CHECK ]]
  then 
    echo -e "\nwhatz ya name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME') ")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nwelcome back" $CUSTOMER_NAME
  fi
}

GET_SERVICE_TIME() {
  echo -e "\nwhat time should d appointmnt be @?"
  read SERVICE_TIME
}

SET_APPOINTMENT() {
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

AFTER_MAIN() {
  GET_PERSONAL_DATA
  GET_SERVICE_TIME
  SET_APPOINTMENT
}


EXIT() {
  echo "c ya"
}

MAIN_MENU