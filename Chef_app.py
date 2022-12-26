from mysql.connector import connect, Error
from getpass4 import getpass
import pandas as pd
from datetime import date
from datetime import datetime
import warnings

try:
    conn = connect(
            host= 'localhost',
            user= input('Enter Username'),
            password = getpass('Enter Password'),
            database= 'restaurant')
except Error as e:
    print(e)

#Chef application
warnings.filterwarnings(action = 'ignore', category = UserWarning)
print("Welcome Chef!")
print("Below are the orders:")
#show pending orders
order_view = "SELECT * FROM chef_order"
order_data = pd.read_sql(order_view, conn)
print(order_data)


#assignement and reassignment of pending orders
assign = input("Would you like to assign chefs to any current open orders? ('yes' or 'no')")
assign = assign.lower()
if assign == 'yes':
    order_id = input("Enter the order id of the open order")
    try:
        order_id = int(order_id)
    except ValueError:
        print("Non integer value entered")
        order_id = input("Re -enter the order id of the open order")
        order_id = int(order_id)
    
    chef_id = input("Enter the chef id of the chef you would like to assign")
    try:
        chef_id = int(chef_id)
    except ValueError as e:
        print("Non integer value entered")
        chef_id = input("Re-enter the chef id of the chef you would like to assign")
        chef_id = int(chef_id)
    
    #insert assignment
    assign_query = """INSERT INTO views VALUES(%s,%s)"""
    chef_tuple = (order_id,chef_id)
    try:
        with conn.cursor() as cursor:
            cursor.execute(assign_query,chef_tuple)
            conn.commit()
    except Error as e:
        print(e)
        conn.close()
    print("Thank you for your input. Below are the current pending orders with the updates")
    
    #Show pending orders
    new_order_view = "SELECT * FROM chef_order"
    new_order_data = pd.read_sql(new_order_view, conn)
    print(new_order_data)
print("")
print("")
print("")

#Updating inventory
print("Below is the current inventory of all ingredients")

#display chef inventory view
inventory_view = "SELECT * FROM chef_inventory"
inventory_data = pd.read_sql(inventory_view, conn)
print(inventory_data)

inv = input("Would you like to update the inventory of any ingredients? ('yes' or 'no)")
inv = inv.lower()
if inv == 'yes':
    num_items = input("How many ingredients would you like to update?")
    try:
        num_items  = int(num_items)
    except ValueError as e:
        print("Non Integer Value Entered")
        num_items = input("Re-enter: How many ingredients would you like to update?")
        num_items  = int(num_items)
    
    for i in range(num_items):
        num = str(i + 1)
        i_id = input("Enter ingredient id for ingredient " + num)
        inv_qty = input("Enter new inventory quantity")
        try:
            inv_qty = int(inv_qty)
        except ValueError:
            print("Non Integer Value Entered")
            inv_qty = input("Re-enter new inventory quantity")
            inv_qty = int(inv_qty)
            
        inv_tuple = (i_id, inv_qty)
        try:
            with conn.cursor() as cursor:
                cursor.callproc('modify_ing_quantity',inv_tuple)
                conn.commit()
        except Error as e:
            print(e)
            conn.close()
        
        print("Thank you for your input. Below is the updated inventory.")
        #display inventory chef view again
        new_view = "SELECT * FROM chef_inventory"
        new_data = pd.read_sql(new_view, conn)
        print(new_data)

#Exit program
print("Northeastern Dining thanks you for your time! We appreciate your hard work!") 
conn.close()
