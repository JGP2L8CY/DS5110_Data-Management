from mysql.connector import connect, Error
import pandas as pd
from getpass4 import getpass
from datetime import date
from datetime import datetime
import warnings

try:
    conn = connect(
        host= 'localhost',
        user= input('Enter Username'),
    password= getpass('Enter Password'),
        database= 'restaurant')
except Error as e:
    print(e)

warnings.filterwarnings(action = 'ignore', category = UserWarning)
try:
    curs = conn.cursor()
except Error as e:
    print(e)
    conn.close()

print("Welcome Waiter!")

print("Below are all reservations")

waiter_view = "SELECT * FROM waiter_view"
order_data = pd.read_sql(waiter_view, conn)
print(order_data)


assign = input("Do you want to check if customer reservation needs a table reassignment? ('yes' or 'no')")
assign = assign.lower()
if assign == 'yes':
    reservation_id = input("Enter the reservation id of the reservation")
    try:
        reservation_id = int(reservation_id)
    except ValueError:
        reservation_id = input("Re-enter the reservation id of the reservation")
        reservation_id = int(reservation_id)
    try:
        if pd.read_sql('select customer_reservation({reservation_id})'.format(reservation_id = reservation_id),
            conn).values[0][0] == 'Reservation Successful':
            curs.execute('update waiter_view set table_status = "closed" where reservation_id = {reservation_id}'.format(reservation_id =
                                                                                                                 reservation_id))
            print("Reservation Successful")
        else:
            print("Reservation Unsuccessful")
    except Error as e:
        print(e)
        conn.close()

conn.close()
print("Northeastern Dining thanks you for your time! We appreciate your hard work!") 
